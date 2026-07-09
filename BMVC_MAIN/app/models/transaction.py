from datetime import datetime


CATEGORIAS_RECEITA = ['Salario', 'Freelance', 'Investimentos', 'Aluguel Recebido', 'Outros']
CATEGORIAS_DESPESA = ['Alimentacao', 'Transporte', 'Moradia', 'Saude', 'Educacao', 'Lazer', 'Utilidades', 'Outros']


class Transaction:
    """
    Modelo de transacao financeira com encapsulamento completo.
    Nivel BMVC: Model (M)
    """

    def __init__(self, id, username, tipo, categoria, descricao, valor, data=''):
        self.__id        = id
        self.__username  = username
        self.__tipo      = tipo        # 'receita' ou 'despesa'
        self.__categoria = categoria
        self.__descricao = descricao
        self.__valor     = float(valor)
        self.__data      = data if data else datetime.now().strftime('%Y-%m-%d')

    # --- Getters (encapsulamento) ---

    @property
    def id(self):
        return self.__id

    @property
    def username(self):
        return self.__username

    @property
    def tipo(self):
        return self.__tipo

    @property
    def categoria(self):
        return self.__categoria

    @property
    def descricao(self):
        return self.__descricao

    @property
    def valor(self):
        return self.__valor

    @property
    def data(self):
        return self.__data

    # --- Metodos de negocio ---

    def is_receita(self):
        return self.__tipo == 'receita'

    def is_despesa(self):
        return self.__tipo == 'despesa'

    def update(self, tipo=None, categoria=None, descricao=None, valor=None, data=None):
        if tipo:      self.__tipo      = tipo
        if categoria: self.__categoria = categoria
        if descricao: self.__descricao = descricao
        if valor is not None: self.__valor = float(valor)
        if data:      self.__data      = data

    def to_dict(self):
        return {
            'id':        self.__id,
            'username':  self.__username,
            'tipo':      self.__tipo,
            'categoria': self.__categoria,
            'descricao': self.__descricao,
            'valor':     self.__valor,
            'data':      self.__data,
        }

    def __repr__(self):
        return f'Transaction(id={self.__id}, tipo={self.__tipo}, valor={self.__valor})'
