import os
from typing import Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """应用配置"""
    
    # API配置
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "灵启 API"
    PROJECT_DESCRIPTION: str = "基于FastAPI和LangChain的LLM应用"
    
    # OpenAI配置
    OPENAI_API_KEY: Optional[str] = None
    OPENAI_API_BASE: Optional[str] = None
    OPENAI_MODEL: str = "gpt-3.5-turbo"
    
    # 默认聊天参数
    DEFAULT_TEMPERATURE: float = 0.7
    DEFAULT_MAX_TOKENS: int = 1000
    DEFAULT_SYSTEM_PROMPT: str = "你是一个有用的AI助手。"
    
    # CORS配置
    CORS_ORIGINS: list[str] = ["*"]
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: list[str] = ["*"]
    CORS_ALLOW_HEADERS: list[str] = ["*"]
    
    class Config:
        env_file = ".env"
        case_sensitive = True
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # 从环境变量加载OpenAI配置
        self.OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", self.OPENAI_API_KEY)
        self.OPENAI_API_BASE = os.getenv("OPENAI_API_BASE", self.OPENAI_API_BASE)
        self.OPENAI_MODEL = os.getenv("OPENAI_MODEL", self.OPENAI_MODEL)


settings = Settings()