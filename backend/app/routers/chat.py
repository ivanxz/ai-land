from fastapi import APIRouter

from app.models.chat import ChatRequest, ChatResponse
from app.controller.chat import chat_controller

router = APIRouter(prefix="/chat", tags=["chat"])


@router.post("/", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """非流式聊天接口"""
    return await chat_controller.chat(request)


@router.post("/stream")
async def chat_stream(request: ChatRequest):
    """流式聊天接口，使用SSE"""
    return await chat_controller.chat_stream(request)