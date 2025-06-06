"""自定义异常类"""


class ChatServiceException(Exception):
    """聊天服务异常"""
    pass


class ConfigurationException(Exception):
    """配置异常"""
    pass


class ValidationException(Exception):
    """验证异常"""
    pass 