"""依赖注入模块"""

from typing import Annotated

from fastapi import Header, HTTPException, Depends


async def get_token_header(x_token: Annotated[str, Header()]):
    """验证token头部"""
    if x_token != "fake-super-secret-token":
        raise HTTPException(status_code=400, detail="X-Token header invalid")


async def get_query_token(token: str):
    """验证查询token"""
    if token != "jessica":
        raise HTTPException(status_code=400, detail="No Jessica token provided")