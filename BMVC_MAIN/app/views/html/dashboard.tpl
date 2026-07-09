<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FinanceGest – Dashboard</title>
  <link rel="stylesheet" href="/static/css/style.css">
  <link rel="stylesheet" href="/static/css/app.css">
</head>
<body class="app-body">

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <svg viewBox="0 0 32 32" width="30" height="30" fill="none">
        <rect width="32" height="32" rx="8" fill="#4f46e5"/>
        <path d="M8 16h16M16 8v16" stroke="#fff" stroke-width="2.5" stroke-linecap="round"/>
      </svg>
      <span>FinanceGest</span>
    </div>
    <nav class="sidebar-nav">
      <a href="/dashboard/{{username}}" class="nav-item active">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
          <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
        </svg>
        <span>Dashboard</span>
      </a>
      <a href="/transacoes/{{username}}" class="nav-item">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
          <rect x="9" y="3" width="6" height="4" rx="1"/><line x1="9" y1="12" x2="15" y2="12"/>
          <line x1="9" y1="16" x2="13" y2="16"/>
        </svg>
        <span>Transações</span>
      </a>
      <a href="/relatorios/{{username}}" class="nav-item">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
        </svg>
        <span>Relatórios</span>
      </a>
    </nav>
    <div class="sidebar-bottom">
      <div class="sidebar-user">
        <div class="user-avatar">{{username[0].upper()}}</div>
        <div class="user-info">
          <span class="user-name">{{username}}</span>
          <span class="user-role">Usuário</span>
        </div>
      </div>
      <form action="/logout" method="post">
        <button type="submit" class="btn-logout">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/>
            <polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
          Sair
        </button>
      </form>
    </div>
  </aside>

  <!-- Conteudo Principal -->
  <main class="main-content">
    <header class="page-header">
      <div>
        <h2>Dashboard</h2>
        <p class="subtitle">Bem-vindo, <strong>{{username}}</strong>! Visão geral das suas finanças.</p>
      </div>
      <div class="ws-badge" id="wsBadge">
        <span class="ws-dot" id="wsDot"></span>
        <span id="wsLabel">Conectando...</span>
      </div>
    </header>

    <!-- Cards de Saldo (Nivel 1+2) -->
    <div class="cards-grid">
      <div class="card card-saldo">
        <div class="card-icon icon-indigo">
          <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
          </svg>
        </div>
        <div class="card-body">
          <span class="card-label">Saldo Total</span>
          <span class="card-value" id="saldo">
            % saldo = balance['saldo']
            % cls = 'val-pos' if saldo >= 0 else 'val-neg'
            <span class="{{cls}}">
              R$ {{'{:,.2f}'.format(abs(saldo)).replace(',','X').replace('.',',').replace('X','.')}}
            </span>
          </span>
        </div>
      </div>

      <div class="card card-receita">
        <div class="card-icon icon-green">
          <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
            <polyline points="17 6 23 6 23 12"/>
          </svg>
        </div>
        <div class="card-body">
          <span class="card-label">Total Receitas</span>
          <span class="card-value val-pos" id="receitas">
            R$ {{'{:,.2f}'.format(balance['receitas']).replace(',','X').replace('.',',').replace('X','.')}}
          </span>
        </div>
      </div>

      <div class="card card-despesa">
        <div class="card-icon icon-red">
          <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2">
            <polyline points="23 18 13.5 8.5 8.5 13.5 1 6"/>
            <polyline points="17 18 23 18 23 12"/>
          </svg>
        </div>
        <div class="card-body">
          <span class="card-label">Total Despesas</span>
          <span class="card-value val-neg" id="despesas">
            R$ {{'{:,.2f}'.format(balance['despesas']).replace(',','X').replace('.',',').replace('X','.')}}
          </span>
        </div>
      </div>
    </div>

    <!-- Transacoes Recentes -->
    <div class="section-card">
      <div class="section-header">
        <h3>Transações Recentes</h3>
        <a href="/transacoes/{{username}}" class="btn btn-outline btn-sm">Ver todas →</a>
      </div>

      % if recent:
      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>Data</th>
              <th>Descrição</th>
              <th>Categoria</th>
              <th>Tipo</th>
              <th>Valor</th>
            </tr>
          </thead>
          <tbody>
            % for tx in recent:
            <tr>
              <td>{{tx.data}}</td>
              <td>{{tx.descricao}}</td>
              <td><span class="badge badge-cat">{{tx.categoria}}</span></td>
              <td>
                % if tx.is_receita():
                <span class="badge badge-receita">Receita</span>
                % else:
                <span class="badge badge-despesa">Despesa</span>
                % end
              </td>
              <td class="{{'col-receita' if tx.is_receita() else 'col-despesa'}}">
                {{'+ ' if tx.is_receita() else '- '}}R$ {{'{:,.2f}'.format(tx.valor).replace(',','X').replace('.',',').replace('X','.')}}
              </td>
            </tr>
            % end
          </tbody>
        </table>
      </div>
      % else:
      <div class="empty-state">
        <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="#94a3b8" stroke-width="1.5">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
          <rect x="9" y="3" width="6" height="4" rx="1"/>
        </svg>
        <p>Nenhuma transação registrada ainda.</p>
        <a href="/transacoes/{{username}}" class="btn btn-primary btn-sm">Adicionar primeira transação</a>
      </div>
      % end
    </div>

    <!-- Adicionar transacao rapida -->
    <div class="section-card">
      <h3 class="section-title">Adicionar Transação Rápida</h3>
      <form action="/transacoes/{{username}}/add" method="post" class="quick-form">
        <select name="tipo" id="qTipo" onchange="updateQuickCats()" required>
          <option value="receita">Receita</option>
          <option value="despesa">Despesa</option>
        </select>
        <select name="categoria" id="qCat" required></select>
        <input type="text" name="descricao" placeholder="Descrição" required>
        <input type="number" name="valor" step="0.01" min="0.01" placeholder="R$ 0,00" required>
        <input type="date" name="data" id="qData" required>
        <button type="submit" class="btn btn-primary">+ Adicionar</button>
      </form>
    </div>
  </main>

  <script>
    const WS_USERNAME     = '{{username}}';
    const CAT_RECEITA     = ["Salario","Freelance","Investimentos","Aluguel Recebido","Outros"];
    const CAT_DESPESA     = ["Alimentacao","Transporte","Moradia","Saude","Educacao","Lazer","Utilidades","Outros"];
  </script>
  <script src="/static/js/main.js"></script>
  <script src="/static/js/dashboard.js"></script>
</body>
</html>
