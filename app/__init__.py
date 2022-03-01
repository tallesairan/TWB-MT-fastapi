from fastapi import FastAPI

from app.api.translateAPI import load_models
from app.constants import CONFIG_JSON_PATH

def create_app():
    app = FastAPI()

    from app.api.translateAPI import translate
    app.include_router(translate)

    @app.on_event('startup')
    async def startup_event():
        load_models(CONFIG_JSON_PATH)

    return app
