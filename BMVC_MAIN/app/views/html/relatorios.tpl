<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FinanceGest – Relatórios</title>
  <link rel="stylesheet" href="/static/css/style.css">
  <link rel="stylesheet" href="/static/css/app.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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
      <a href="/dashboard/{{username}}" class="nav-item">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
          <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
        </svg>
        <span>Dashboard</span>
      </a>
      <a href="/transacoes/{{username}}" class="nav-item">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
          <rect x="9" y="3" width="6" height="4" rx="1"/>
        </svg>
        <span>Transações</span>
      </a>
      <a href="/relatorios/{{username}}" class="nav-item active">
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

  <!-- Conteudo -->
  <main class="main-content">
    <header class="page-header">
      <div>
        <h2>Relatórios Financeiros</h2>
        <p class="subtitle">Análise detalhada das suas finanças pessoais</p>
      </div>
    </header>

    <!-- Cards de resumo -->
    <div class="cards-grid">
      <div class="card card-saldo">
        <div class="card-body">
          <span class="card-label">Saldo Atual</span>
          % saldo = balance['saldo']
          <span class="card-value {{'val-pos' if saldo >= 0 else 'val-neg'}}">
            R$ {{'{:,.2f}'.format(abs(saldo)).replace(',','X').replace('.',',').replace('X','.')}}
          </span>
        </div>
      </div>
      <div class="card card-receita">
        <div class="card-body">
          <span class="card-label">Total Receitas</span>
          <span class="card-value val-pos">
            R$ {{'{:,.2f}'.format(balance['receitas']).replace(',','X').replace('.',',').replace('X','.')}}
          </span>
        </div>
      </div>
      <div class="card card-despesa">
        <div class="card-body">
          <span class="card-label">Total Despesas</span>
          <span class="card-value val-neg">
            R$ {{'{:,.2f}'.format(balance['despesas']).replace(',','X').replace('.',',').replace('X','.')}}
          </span>
        </div>
      </div>
    </div>

    <!-- Graficos com Chart.js -->
    <div class="charts-grid">
      <div class="section-card">
        <h3 class="section-title">Receitas vs Despesas por Mês</h3>
        <div class="chart-wrap">
          <canvas id="monthlyChart"></canvas>
        </div>
      </div>
      <div class="section-card">
        <h3 class="section-title">Distribuição por Categoria</h3>
        <div class="chart-wrap chart-pie">
          <canvas id="categoryChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Tabela mensal -->
    % if monthly:
    <div class="section-card">
      <h3 class="section-title">Resumo por Mês</h3>
      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>Mês</th>
              <th>Receitas</th>
              <th>Despesas</th>
              <th>Saldo do Mês</th>
            </tr>
          </thead>
          <tbody>
            % for mes, vals in monthly.items():
            % saldo_mes = vals['receitas'] - vals['despesas']
            <tr>
              <td><strong>{{mes}}</strong></td>
              <td class="col-receita">
                R$ {{'{:,.2f}'.format(vals['receitas']).replace(',','X').replace('.',',').replace('X','.')}}
              </td>
              <td class="col-despesa">
                R$ {{'{:,.2f}'.format(vals['despesas']).replace(',','X').replace('.',',').replace('X','.')}}
              </td>
              <td class="{{'col-receita' if saldo_mes >= 0 else 'col-despesa'}}">
                R$ {{'{:,.2f}'.format(saldo_mes).replace(',','X').replace('.',',').replace('X','.')}}
              </td>
            </tr>
            % end
          </tbody>
        </table>
      </div>
    </div>
    % end

  </main>

  <script>
    const MONTHLY_DATA = {{!str(monthly)}};
    const CATS_DATA    = {{!str(cats)}};
  </script>
  <script src="/static/js/main.js"></script>
  <script src="/static/js/relatorios.js"></script>
</body>
</html>
