# 项目架构文档

## 项目结构

```
app/
├── controller/          # 控制器层
│   ├── __init__.py
│   └── chat.py         # 聊天控制器
├── services/           # 服务层
│   ├── __init__.py
│   └── chat_service.py # 聊天服务
├── models/             # 数据模型层
│   ├── __init__.py
│   └── chat.py         # 聊天相关模型
├── routers/            # 路由层
│   ├── __init__.py
│   └── chat.py         # 聊天路由
├── core/               # 核心模块
│   ├── __init__.py
│   ├── config.py       # 配置管理
│   ├── exceptions.py   # 自定义异常
│   └── utils.py        # 工具类
├── deps.py             # 依赖注入
└── main.py             # 应用入口
```

## 分层架构

### 1. Router层 (路由层)
- **职责**: 定义API路由，处理HTTP请求和响应
- **特点**: 
  - 只负责路由定义
  - 不包含业务逻辑
  - 调用Controller层处理请求

### 2. Controller层 (控制器层)
- **职责**: 处理HTTP请求，调用服务层，处理异常
- **特点**:
  - 处理请求参数验证
  - 调用Service层执行业务逻辑
  - 统一异常处理和响应格式化

### 3. Service层 (服务层)
- **职责**: 核心业务逻辑处理
- **特点**:
  - 包含具体的业务逻辑
  - 调用外部API（如OpenAI）
  - 数据处理和转换

### 4. Model层 (模型层)
- **职责**: 定义数据结构和验证规则
- **特点**:
  - 使用Pydantic进行数据验证
  - 定义请求和响应模型
  - 包含字段验证规则

### 5. Core层 (核心层)
- **职责**: 提供核心功能和工具
- **包含**:
  - `config.py`: 应用配置管理
  - `exceptions.py`: 自定义异常类
  - `utils.py`: 工具类和辅助函数

## 设计原则

### 1. 单一职责原则
每个层级和模块都有明确的职责，避免功能混杂。

### 2. 依赖倒置原则
高层模块不依赖低层模块，都依赖于抽象。

### 3. 开闭原则
对扩展开放，对修改关闭。新功能通过扩展实现。

### 4. 接口隔离原则
使用依赖注入，便于测试和维护。

## 数据流

```
HTTP Request → Router → Controller → Service → External API
                ↓         ↓          ↓
HTTP Response ← Router ← Controller ← Service ← External API
```

## 配置管理

- 使用 `pydantic-settings` 进行配置管理
- 支持环境变量和 `.env` 文件
- 集中化配置，便于维护

## 异常处理

- 自定义异常类，便于错误分类
- 在Controller层统一处理异常
- 提供友好的错误信息

## 扩展性

- 新增功能时，按照分层架构添加对应的模块
- 使用依赖注入，便于单元测试
- 配置化管理，便于部署到不同环境 