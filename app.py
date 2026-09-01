# main.py
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="API de Músicas")

class Musica(BaseModel):
    id: Optional[int] = None
    titulo: str
    artista: str
    album: Optional[str] = None
    ano: Optional[int] = None
    

# Banco de dados em memória
db_musicas = [
    {
        "id": 1,
        "titulo": "Bohemian Rhapsody",
        "artista": "Queen",
        "album": "A Night at the Opera",
        "ano": 1975
    },
    {
        "id": 2,
        "titulo": "Billie Jean",
        "artista": "Michael Jackson",
        "album": "Thriller",
        "ano": 1982
    },
    {
        "id": 3,
        "titulo": "Smells Like Teen Spirit",
        "artista": "Nirvana",
        "album": "Nevermind",
        "ano": 1991
    },
    {
        "id": 4,
        "titulo": "Hotel California",
        "artista": "Eagles",
        "album": "Hotel California",
        "ano": 1976
    },
    {
        "id": 5,
        "titulo": "Sweet Child O' Mine",
        "artista": "Guns N' Roses",
        "album": "Appetite for Destruction",
        "ano": 1987
    }
]
db_musicas: List[Musica] = []
contador_id = 1

@app.get("/")
def root():
    return {
        "mensagem": "API de Músicas funcionando!",
        "status": "online"
    }


@app.get("/musicas", response_model=List[Musica])
def listar_musicas():
    return db_musicas

@app.get("/musicas/{musica_id}", response_model=Musica)
def buscar_musica(musica_id: int):
    for m in db_musicas:
        if m.id == musica_id:
            return m
    raise HTTPException(status_code=404, detail="Música não encontrada")

@app.post("/musicas", response_model=Musica, status_code=status.HTTP_201_CREATED)
def cadastrar_musica(musica: Musica):
    global contador_id
    musica.id = contador_id
    contador_id += 1
    db_musicas.append(musica)
    return musica

@app.put("/musicas/{musica_id}", response_model=Musica)
def atualizar_musica(musica_id: int, dados: Musica):
    for index, m in enumerate(db_musicas):
        if m.id == musica_id:
            dados.id = musica_id
            db_musicas[index] = dados
            return dados
    raise HTTPException(status_code=404, detail="Música não encontrada")

@app.delete("/musicas/{musica_id}", status_code=status.HTTP_204_NO_CONTENT)
def excluir_musica(musica_id: int):
    for index, m in enumerate(db_musicas):
        if m.id == musica_id:
            db_musicas.pop(index)
            return
    raise HTTPException(status_code=404, detail="Música não encontrada")