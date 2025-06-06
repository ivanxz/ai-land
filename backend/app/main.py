from fastapi import APIRouter, FastAPI
from fastapi.responses import RedirectResponse
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.routers import chat

from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

app = FastAPI(
    title=settings.PROJECT_NAME, 
    description=settings.PROJECT_DESCRIPTION
)

# 添加CORS中间件
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=settings.CORS_ALLOW_CREDENTIALS,
    allow_methods=settings.CORS_ALLOW_METHODS,
    allow_headers=settings.CORS_ALLOW_HEADERS,
)

api_router = APIRouter()
api_router.include_router(chat.router)

app.include_router(api_router, prefix=settings.API_V1_STR)

@app.get("/")
async def redirect_root_to_docs():
    return RedirectResponse("/docs")

@app.get("/health")
async def health_check():
    return {"status": "healthy"}