# LangChain LLM API

基于FastAPI和LangChain构建的简单LLM应用，支持API访问和SSE（Server-Sent Events）流式输出。

## 功能特性

- 🚀 基于FastAPI的高性能异步API
- 🤖 集成LangChain和OpenAI GPT模型
- 📡 支持SSE流式输出
- 🔧 可配置的模型参数（temperature、max_tokens等）
- 🌐 CORS支持，便于前端集成
- 📝 完整的API文档（Swagger UI）

## 安装依赖

```bash
# 安装项目依赖
uv sync
```

## 环境配置

创建 `.env` 文件并设置OpenAI API密钥：

```bash
OPENAI_API_KEY=your_openai_api_key_here
```

## 启动服务

```bash
# 方式1：直接运行
python -m app.main

# 方式2：使用uvicorn
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

服务启动后，访问 http://localhost:8000 查看API状态。

## API接口

### 1. 健康检查
```
GET /api/health
```

### 2. 普通聊天接口
```
POST /api/chat
```

请求体：
```json
{
    "message": "你好，请介绍一下自己",
    "system_prompt": "你是一个友好的AI助手",
    "temperature": 0.7,
    "max_tokens": 1000
}
```

### 3. SSE流式聊天接口
```
POST /api/chat/stream
```

返回Server-Sent Events格式的流式数据：
```
data: {"type": "token", "content": "你好"}
data: {"type": "token", "content": "！"}
data: {"type": "end", "content": ""}
```

## API文档

启动服务后，访问以下地址查看自动生成的API文档：

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
