<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FinanceGest – Transações</title>
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
      <a href="/dashboard/{{username}}" class="nav-item">
        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
          <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
          <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
        </svg>
        <span>Dashboard</span>
      </a>
      <a href="/transacoes/{{username}}" class="nav-item active">
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

  <!-- Conteudo -->
  <main class="main-content">
    <header class="page-header">
      <div>
        <h2>Transações</h2>
        <p class="subtitle">Gerencie todas as suas receitas e despesas (CRUD completo)</p>
      </div>
    </header>

    <!-- Formulario Adicionar / Editar (Nivel 2 - CRUD) -->
    <div class="section-card">
      % if edit_tx:
      <h3 class="section-title">✏ Editar Transação</h3>
      <form action="/transacoes/{{username}}/edit/{{edit_tx.id}}" method="post" class="tx-form">
      % else:
      <h3 class="section-title">+ Nova Transação</h3>
      <form action="/transacoes/{{username}}/add" method="post" class="tx-form">
      % end

        <div class="form-row">
          <div class="form-group">
            <label>Tipo</label>
            <select name="tipo" id="tipoSelect" required onchange="updateCategorias()">
              % if edit_tx and edit_tx.tipo == 'receita':
              <option value="receita" selected>Receita</option>
              <option value="despesa">Despesa</option>
              % elif edit_tx:
              <option value="receita">Receita</option>
              <option value="despesa" selected>Despesa</option>
              % else:
              <option value="receita">Receita</option>
              <option value="despesa">Despesa</option>
              % end
            </select>
          </div>

          <div class="form-group">
            <label>Categoria</label>
            <select name="categoria" id="categoriaSelect" required>
              % if edit_tx:
                % cats = cat_receita if edit_tx.tipo == 'receita' else cat_despesa
                % for c in cats:
                  % if c == edit_tx.categoria:
                  <option value="{{c}}" selected>{{c}}</option>
                  % else:
                  <option value="{{c}}">{{c}}</option>
                  % end
                % end
              % else:
                % for c in cat_receita:
                <option value="{{c}}">{{c}}</option>
                % end
              % end
            </select>
          </div>

          <div class="form-group flex-3">
            <label>Descrição</label>
            <input type="text" name="descricao" placeholder="Ex: Salário, Supermercado..."
              value="{{'%s' % edit_tx.descricao if edit_tx else ''}}" required>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>Valor (R$)</label>
            <input type="number" name="valor" step="0.01" min="0.01" placeholder="0,00"
              value="{{'%.2f' % edit_tx.valor if edit_tx else ''}}" required>
          </div>
          <div class="form-group">
            <label>Data</label>
            <input type="date" name="data" id="dataInput"
              value="{{'%s' % edit_tx.data if edit_tx else ''}}" required>
          </div>
          <div class="form-group form-actions-group">
            <label>&nbsp;</label>
            <div class="form-actions">
              % if edit_tx:
              <button type="submit" class="btn btn-primary">Salvar</button>
              <a href="/transacoes/{{username}}" class="btn btn-outline">Cancelar</a>
              % else:
              <button type="submit" class="btn btn-primary">Adicionar</button>
              % end
            </div>
          </div>
        </div>
      </form>
    </div>

    <!-- Lista / Historico (Nivel 2 - CRUD: Read + Delete) -->
    <div class="section-card">
      <div class="section-header">
        <h3>Histórico de Transações</h3>
        <div class="filter-group">
          <input type="text" id="searchInput" placeholder="🔍 Buscar..."
                 onkeyup="filterTable()" class="filter-input">
          <select id="tipoFilter" onchange="filterTable()" class="filter-select">
            <option value="">Todos os tipos</option>
            <option value="receita">Somente Receitas</option>
            <option value="despesa">Somente Despesas</option>
          </select>
        </div>
      </div>

      % if transacoes:
      <div class="table-wrap">
        <table class="data-table" id="txTable">
          <thead>
            <tr>
              <th>Data</th>
              <th>Descrição</th>
              <th>Categoria</th>
              <th>Tipo</th>
              <th>Valor</th>
              <th>Ações</th>
            </tr>
          </thead>
          <tbody>
            % for tx in transacoes:
            <tr data-tipo="{{tx.tipo}}">
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
              <td class="actions-cell">
                <a href="/transacoes/{{username}}/edit/{{tx.id}}"
                   class="btn-icon btn-edit" title="Editar">✏</a>
                <form action="/transacoes/{{username}}/delete/{{tx.id}}" method="post"
                      style="display:inline"
                      onsubmit="return confirm('Excluir esta transação?')">
                  <button type="submit" class="btn-icon btn-delete" title="Excluir">🗑</button>
                </form>
              </td>
            </tr>
            % end
          </tbody>
        </table>
      </div>
      <p class="table-count" id="tableCount"></p>
      % else:
      <div class="empty-state">
        <p>Nenhuma transação registrada. Use o formulário acima para adicionar.</p>
      </div>
      % end
    </div>
  </main>

  <script>
    const CAT_RECEITA = {{!str(cat_receita)}};
    const CAT_DESPESA = {{!str(cat_despesa)}};
  </script>
  <script src="/static/js/main.js"></script>
  <script src="/static/js/transacoes.js"></script>
</body>
</html>
