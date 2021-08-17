from typing import List

from numpy import array
from pandas import DataFrame
from pydantic import BaseModel

from iris_model_training.helpers import ModelIO
from iris_model_training.feature_engineering import Transformer


clf = ModelIO.load()


class Features(BaseModel):
    sl: float
    sw: float
    pl: float
    pw: float


class LambdaEvent(BaseModel):
    input: List[Features]

    def to_df(self):
        return DataFrame((f.dict() for f in self.input))


def handler(event, _):
    # event is coming in as json, not a dataframe!
    # GOAL:: Convert the incoming data (the json event) to the same data
    # structure that was used during model training. If we do this,
    # then we can "recycle" a lot of code from the model training repo.

    column_map = column_map = {
        "sl": "SepalLengthCm",
        "sw": "SepalWidthCm",
        "pl": "PetalLengthCm",
        "pw": "PetalWidthCm",
    }

    features = LambdaEvent(**event) \
        .to_df() \
        .rename(column_map, axis=1)

    features = Transformer.apply(features)

    response: array = clf.predict(features)
    response = response.tolist()

    return {"prediction": response}


if __name__ == '__main__':
    handler(None, None)
