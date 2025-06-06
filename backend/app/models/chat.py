from typing import Optional
from pydantic import BaseModel, Field

from app.core.config import settings


class ChatRequest(BaseModel):
    message: str = Field(..., description="用户消息")
    system_prompt: Optional[str] = Field(
        default=settings.DEFAULT_SYSTEM_PROMPT, 
        description="系统提示词"
    )
    temperature: Optional[float] = Field(
        default=settings.DEFAULT_TEMPERATURE, 
        ge=0.0, 
        le=2.0, 
        description="温度参数，控制回复的随机性"
    )
    max_tokens: Optional[int] = Field(
        default=settings.DEFAULT_MAX_TOKENS, 
        gt=0, 
        le=4000, 
        description="最大token数"
    )


class ChatResponse(BaseModel):
    response: str = Field(..., description="AI回复内容")