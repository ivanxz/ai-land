"""工具类和辅助函数"""

import json
from typing import Any, Dict


class SSEFormatter:
    """Server-Sent Events格式化器"""
    
    @staticmethod
    def format_data(data: Dict[str, Any]) -> str:
        """格式化数据为SSE格式"""
        return f"data: {json.dumps(data, ensure_ascii=False)}\n\n"
    
    @staticmethod
    def format_token(content: str) -> str:
        """格式化token数据"""
        data = {"type": "token", "content": content}
        return SSEFormatter.format_data(data)
    
    @staticmethod
    def format_end() -> str:
        """格式化结束信号"""
        data = {"type": "end", "content": ""}
        return SSEFormatter.format_data(data)
    
    @staticmethod
    def format_error(error_message: str) -> str:
        """格式化错误信息"""
        data = {"type": "error", "content": f"错误: {error_message}"}
        return SSEFormatter.format_data(data)


class ResponseHeaders:
    """响应头工具类"""
    
    @staticmethod
    def get_sse_headers() -> Dict[str, str]:
        """获取SSE响应头"""
        return {
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
        } 