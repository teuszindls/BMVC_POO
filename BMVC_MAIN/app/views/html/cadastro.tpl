<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FinanceGest – Cadastro</title>
  <link rel="stylesheet" href="/static/css/style.css">
  <link rel="stylesheet" href="/static/css/auth.css">
</head>
<body class="auth-body">

  <div class="auth-wrapper auth-wrapper-single">
    <div class="auth-card">

      <div class="auth-logo">
        <svg viewBox="0 0 48 48" width="56" height="56" fill="none">
          <rect width="48" height="48" rx="14" fill="#4f46e5"/>
          <path d="M14 24h20M24 14v20" stroke="#fff" stroke-width="3.5" stroke-linecap="round"/>
          <circle cx="24" cy="24" r="7" fill="#4f46e5" stroke="#fff" stroke-width="2.5"/>
        </svg>
        <div>
          <h1>FinanceGest</h1>
          <p>Criar nova conta</p>
        </div>
      </div>

      % if error:
      <div class="alert alert-danger">⚠ {{error}}</div>
      % end
      % if success:
      <div class="alert alert-success">✓ {{success}}</div>
      % end

      <form action="/cadastro" method="post" class="auth-form">
        <div class="form-group">
          <label for="username">Usuário</label>
          <input id="username" name="username" type="text"
                 placeholder="Escolha um nome de usuário" required autofocus>
        </div>
        <div class="form-group">
          <label for="email">E-mail (opcional)</label>
          <input id="email" name="email" type="email" placeholder="seu@email.com">
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="password">Senha</label>
            <input id="password" name="password" type="password"
                   placeholder="Crie uma senha" required>
          </div>
          <div class="form-group">
            <label for="confirm">Confirmar</label>
            <input id="confirm" name="confirm" type="password"
                   placeholder="Repita a senha" required>
          </div>
        </div>
        <button type="submit" class="btn btn-primary btn-full">Criar Conta</button>
      </form>

      <p class="auth-footer">
        Já tem conta? <a href="/portal">Faça login</a>
      </p>
    </div>
  </div>

  <script src="/static/js/main.js"></script>
</body>
</html>
