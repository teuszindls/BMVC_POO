import json
import uuid
from app.models.user_account import UserAccount
from app.models.transaction import Transaction


class DataRecord:
    """
    Gerenciador do banco de dados JSON.
    Persiste e recupera Usuarios e Transacoes.
    Nivel BMVC: Controller (C) - camada de dados
    """

    _DB_USERS        = 'app/controllers/db/user_accounts.json'
    _DB_TRANSACTIONS = 'app/controllers/db/transactions.json'

    def __init__(self):
        self.__user_accounts       = []
        self.__transactions        = []
        self.__authenticated_users = {}   # {session_id: UserAccount}
        self.__read_users()
        self.__read_transactions()

    # ─── Leitura / Escrita em disco ───────────────────────────────────

    def __read_users(self):
        try:
            with open(self._DB_USERS, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.__user_accounts = [UserAccount(**d) for d in data]
        except (FileNotFoundError, json.JSONDecodeError):
            admin = UserAccount('admin', 'admin123', 'admin@financegest.com')
            self.__user_accounts = [admin]
            self.__write_users()

    def __write_users(self):
        with open(self._DB_USERS, 'w', encoding='utf-8') as f:
            json.dump([u.to_dict() for u in self.__user_accounts],
                      f, ensure_ascii=False, indent=2)

    def __read_transactions(self):
        try:
            with open(self._DB_TRANSACTIONS, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.__transactions = [Transaction(**d) for d in data]
        except (FileNotFoundError, json.JSONDecodeError):
            self.__transactions = []
            self.__write_transactions()

    def __write_transactions(self):
        with open(self._DB_TRANSACTIONS, 'w', encoding='utf-8') as f:
            json.dump([t.to_dict() for t in self.__transactions],
                      f, ensure_ascii=False, indent=2)

    # ─── Usuarios ─────────────────────────────────────────────────────

    def register_user(self, username, password, email=''):
        """Cadastra novo usuario. Retorna False se username ja existe."""
        if self.get_user_by_name(username):
            return False
        self.__user_accounts.append(UserAccount(username, password, email))
        self.__write_users()
        return True

    def get_user_by_name(self, username):
        for u in self.__user_accounts:
            if u.username == username:
                return u
        return None

    def checkUser(self, username, password):
        """Autentica e retorna session_id unico, ou None."""
        user = self.get_user_by_name(username)
        if user and user.check_password(password):
            session_id = str(uuid.uuid4())
            self.__authenticated_users[session_id] = user
            return session_id
        return None

    def getCurrentUser(self, session_id):
        return self.__authenticated_users.get(session_id)

    def getUserName(self, session_id):
        user = self.__authenticated_users.get(session_id)
        return user.username if user else None

    def logout(self, session_id):
        if session_id in self.__authenticated_users:
            del self.__authenticated_users[session_id]

    # ─── Transacoes ───────────────────────────────────────────────────

    def add_transaction(self, username, tipo, categoria, descricao, valor, data=''):
        tid = str(uuid.uuid4())
        t = Transaction(tid, username, tipo, categoria, descricao, valor, data)
        self.__transactions.append(t)
        self.__write_transactions()
        return t

    def get_transactions(self, username):
        return [t for t in self.__transactions if t.username == username]

    def get_transaction_by_id(self, tid):
        for t in self.__transactions:
            if t.id == tid:
                return t
        return None

    def update_transaction(self, tid, tipo, categoria, descricao, valor, data):
        t = self.get_transaction_by_id(tid)
        if not t:
            return False
        t.update(tipo=tipo, categoria=categoria,
                 descricao=descricao, valor=valor, data=data)
        self.__write_transactions()
        return True

    def delete_transaction(self, tid):
        t = self.get_transaction_by_id(tid)
        if not t:
            return False
        self.__transactions.remove(t)
        self.__write_transactions()
        return True

    # ─── Relatorios ───────────────────────────────────────────────────

    def get_balance(self, username):
        txs = self.get_transactions(username)
        receitas = sum(t.valor for t in txs if t.is_receita())
        despesas = sum(t.valor for t in txs if t.is_despesa())
        return {'receitas': receitas, 'despesas': despesas, 'saldo': receitas - despesas}

    def get_monthly_summary(self, username):
        txs = self.get_transactions(username)
        summary = {}
        for t in txs:
            month = t.data[:7]
            if month not in summary:
                summary[month] = {'receitas': 0.0, 'despesas': 0.0}
            if t.is_receita():
                summary[month]['receitas'] += t.valor
            else:
                summary[month]['despesas'] += t.valor
        return dict(sorted(summary.items()))

    def get_category_summary(self, username):
        txs = self.get_transactions(username)
        cats = {}
        for t in txs:
            cats[t.categoria] = cats.get(t.categoria, 0.0) + t.valor
        return cats
