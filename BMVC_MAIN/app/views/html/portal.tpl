<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FinanceGest – Login</title>
  <link rel="stylesheet" href="/static/css/style.css">
  <link rel="stylesheet" href="/static/css/auth.css">
</head>
<body class="auth-body">

  <div class="auth-wrapper">
    <div class="auth-card">

      <div class="auth-logo">
        <svg viewBox="0 0 48 48" width="56" height="56" fill="none">
          <rect width="48" height="48" rx="14" fill="#4f46e5"/>
          <path d="M14 24h20M24 14v20" stroke="#fff" stroke-width="3.5" stroke-linecap="round"/>
          <circle cx="24" cy="24" r="7" fill="#4f46e5" stroke="#fff" stroke-width="2.5"/>
        </svg>
        <div>
          <h1>FinanceGest</h1>
          <p>Gestão Financeira Pessoal</p>
        </div>
      </div>

      % if error:
      <div class="alert alert-danger">⚠ {{error}}</div>
      % end

      <form action="/portal" method="post" class="auth-form">
        <div class="form-group">
          <label for="username">Usuário</label>
          <input id="username" name="username" type="text"
                 placeholder="Digite seu usuário" required autofocus>
        </div>
        <div class="form-group">
          <label for="password">Senha</label>
          <input id="password" name="password" type="password"
                 placeholder="Digite sua senha" required>
        </div>
        <button type="submit" class="btn btn-primary btn-full">Entrar</button>
      </form>

      <p class="auth-footer">
        Não tem conta? <a href="/cadastro">Cadastre-se aqui</a>
      </p>
    </div>

    <div class="auth-info">
      <h2>Controle suas finanças com inteligência</h2>
      <ul>
        <li>✓ Registro de receitas e despesas</li>
        <li>✓ Saldo em tempo real via WebSocket</li>
        <li>✓ Histórico completo de transações</li>
        <li>✓ Relatórios com gráficos</li>
      </ul>
    </div>
  </div>

  <script src="/static/js/main.js"></script>
</body>
</html>
