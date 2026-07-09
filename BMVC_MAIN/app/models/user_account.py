from datetime import datetime


class UserAccount:
    """
    Modelo de conta de usuario com encapsulamento completo.
    Nivel BMVC: Model (M)
    """

    def __init__(self, username, password, email='', created_at=''):
        self.__username  = username
        self.__password  = password
        self.__email     = email
        self.__created_at = created_at if created_at else datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # --- Getters (encapsulamento) ---

    @property
    def username(self):
        return self.__username

    @property
    def password(self):
        return self.__password

    @property
    def email(self):
        return self.__email

    @property
    def created_at(self):
        return self.__created_at

    # --- Metodos de negocio ---

    def check_password(self, password):
        return self.__password == password

    def to_dict(self):
        return {
            'username':   self.__username,
            'password':   self.__password,
            'email':      self.__email,
            'created_at': self.__created_at,
        }

    def __repr__(self):
        return f'UserAccount(username={self.__username}, email={self.__email})'
