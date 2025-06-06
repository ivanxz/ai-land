from typing import AsyncGenerator
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage

from app.models.chat import ChatRequest, ChatResponse
from app.core.exceptions import ChatServiceException
from app.core.config import settings
from app.core.utils import SSEFormatter


class ChatService:
    """聊天服务类，处理聊天相关的业务逻辑"""
    
    def __init__(self):
        self.api_key = settings.OPENAI_API_KEY
        self.api_base = settings.OPENAI_API_BASE
        self.model = settings.OPENAI_MODEL
        
        if not self.api_key:
            raise ChatServiceException("OPENAI_API_KEY环境变量未设置")
    
    def _get_llm(self, temperature: float = 0.7, max_tokens: int = 1000) -> ChatOpenAI:
        """获取LLM实例"""
        return ChatOpenAI(
            api_key=self.api_key,
            openai_api_base=self.api_base,
            model=self.model,
            temperature=temperature,
            max_tokens=max_tokens,
            streaming=True
        )
    
    def _build_messages(self, request: ChatRequest) -> list:
        """构建消息列表"""
        return [
            SystemMessage(content=request.system_prompt),
            HumanMessage(content=request.message)
        ]
    
    async def chat(self, request: ChatRequest) -> ChatResponse:
        """处理非流式聊天请求"""
        try:
            llm = self._get_llm(request.temperature, request.max_tokens)
            messages = self._build_messages(request)
            
            response = await llm.ainvoke(messages)
            return ChatResponse(response=response.content)
        
        except Exception as e:
            raise ChatServiceException(f"处理聊天请求时出错: {str(e)}")
    
    async def chat_stream(self, request: ChatRequest) -> AsyncGenerator[str, None]:
        """处理流式聊天请求"""
        try:
            llm = self._get_llm(request.temperature, request.max_tokens)
            messages = self._build_messages(request)
            
            # 使用流式生成
            async for chunk in llm.astream(messages):
                if chunk.content:
                    yield SSEFormatter.format_token(chunk.content)
            
            # 发送结束信号
            yield SSEFormatter.format_end()
            
        except Exception as e:
            yield SSEFormatter.format_error(str(e))


# 创建服务实例
chat_service = ChatService() 