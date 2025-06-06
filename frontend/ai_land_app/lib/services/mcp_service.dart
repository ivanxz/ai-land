import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mcp_client/mcp_client.dart' as mcp;

class McpService {
  mcp.Client? _mcpClient;
  final _connectionStateController = StreamController<bool>.broadcast();
  final _toolCallResultController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<Map<String, dynamic>> get toolCallResults =>
      _toolCallResultController.stream;

  bool get isConnected => _mcpClient != null && _mcpClient!.isConnected;

  /// 初始化 MCP 客户端
  Future<void> initialize({
    required String serverUrl,
    String? authToken,
    Map<String, String>? headers,
  }) async {
    try {
      // 创建 MCP 客户端
      _mcpClient = mcp.McpClient.createClient(
        name: 'ai_land_mcp_client',
        version: '1.0.0',
        capabilities: const mcp.ClientCapabilities(
          roots: true,
          rootsListChanged: true,
          sampling: true,
        ),
      );

      // 设置事件监听
      _setupEventListeners();

      // 创建传输层
      final transport = await _createTransport(serverUrl, authToken, headers);

      // 连接到服务器
      await _mcpClient!.connectWithRetry(
        transport,
        maxRetries: 3,
        delay: const Duration(seconds: 2),
      );

      _connectionStateController.add(true);
      debugPrint('MCP 客户端连接成功');
    } catch (e) {
      _connectionStateController.add(false);
      debugPrint('MCP 客户端初始化失败: $e');
      rethrow;
    }
  }

  /// 创建传输层
  Future<dynamic> _createTransport(
    String serverUrl,
    String? authToken,
    Map<String, String>? headers,
  ) async {
    final Map<String, String> finalHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };

    if (authToken != null) {
      finalHeaders['Authorization'] = 'Bearer $authToken';
    }

    if (serverUrl.startsWith('http')) {
      // HTTP/SSE 传输
      return mcp.McpClient.createSseTransport(
        serverUrl: serverUrl,
        headers: finalHeaders,
      );
    } else {
      // 标准 I/O 传输（用于本地进程）
      final parts = serverUrl.split(' ');
      return await mcp.McpClient.createStdioTransport(
        command: parts.first,
        arguments: parts.length > 1 ? parts.sublist(1) : [],
      );
    }
  }

  /// 设置事件监听器
  void _setupEventListeners() {
    if (_mcpClient == null) return;

    // 连接状态变化
    _mcpClient!.onConnect.listen((serverInfo) {
      debugPrint('已连接到 MCP 服务器: ${serverInfo.name} v${serverInfo.version}');
      _connectionStateController.add(true);
    });

    _mcpClient!.onDisconnect.listen((reason) {
      debugPrint('MCP 服务器断开连接: $reason');
      _connectionStateController.add(false);
    });

    _mcpClient!.onError.listen((error) {
      debugPrint('MCP 客户端错误: ${error.message}');
    });

    // 工具列表变化
    _mcpClient!.onToolsListChanged(() {
      debugPrint('工具列表已更新');
    });

    // 资源列表变化
    _mcpClient!.onResourcesListChanged(() {
      debugPrint('资源列表已更新');
    });
  }

  /// 获取可用工具列表
  Future<List<mcp.Tool>> getAvailableTools() async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }
    return await _mcpClient!.listTools();
  }

  /// 调用工具
  Future<Map<String, dynamic>> callTool(
    String toolName,
    Map<String, dynamic> arguments,
  ) async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }

    try {
      debugPrint('调用工具: $toolName，参数: $arguments');

      final result = await _mcpClient!.callTool(toolName, arguments);

      final resultData = {
        'toolName': toolName,
        'arguments': arguments,
        'result': result,
        'timestamp': DateTime.now().toIso8601String(),
      };

      _toolCallResultController.add(resultData);

      debugPrint('工具调用成功: $toolName');
      return resultData;
    } catch (e) {
      debugPrint('工具调用失败: $toolName, 错误: $e');
      rethrow;
    }
  }

  /// 获取可用资源列表
  Future<List<mcp.Resource>> getAvailableResources() async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }
    return await _mcpClient!.listResources();
  }

  /// 读取资源
  Future<dynamic> readResource(String resourceUri) async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }
    return await _mcpClient!.readResource(resourceUri);
  }

  /// 获取可用提示模板列表
  Future<List<mcp.Prompt>> getAvailablePrompts() async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }
    return await _mcpClient!.listPrompts();
  }

  /// 获取提示模板结果
  Future<dynamic> getPrompt(
    String promptName,
    Map<String, dynamic> arguments,
  ) async {
    if (!isConnected) {
      throw Exception('MCP 客户端未连接');
    }
    return await _mcpClient!.getPrompt(promptName, arguments);
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (_mcpClient != null) {
      _mcpClient!.disconnect();
      _mcpClient = null;
    }
    _connectionStateController.add(false);
  }

  /// 清理资源
  void dispose() {
    disconnect();
    _connectionStateController.close();
    _toolCallResultController.close();
  }
}
