from fastapi import HTTPException
from fastapi.responses import StreamingResponse

from app.models.chat import ChatRequest, ChatResponse
from app.services.chat import chat_service
from app.core.exceptions import ChatServiceException
from app.core.utils import ResponseHeaders


class ChatController:
    """聊天控制器，处理HTTP请求并调用服务层"""
    
    def __init__(self):
        self.chat_service = chat_service
    
    async def chat(self, request: ChatRequest) -> ChatResponse:
        """处理非流式聊天请求"""
        try:
            return await self.chat_service.chat(request)
        except ChatServiceException as e:
            raise HTTPException(status_code=500, detail=str(e))
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"未知错误: {str(e)}")
    
    async def chat_stream(self, request: ChatRequest) -> StreamingResponse:
        """处理流式聊天请求"""
        try:
            return StreamingResponse(
                self.chat_service.chat_stream(request),
                media_type="text/event-stream",
                headers=ResponseHeaders.get_sse_headers()
            )
        except ChatServiceException as e:
            raise HTTPException(status_code=500, detail=str(e))
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"未知错误: {str(e)}")


# 创建控制器实例
chat_controller = ChatController()