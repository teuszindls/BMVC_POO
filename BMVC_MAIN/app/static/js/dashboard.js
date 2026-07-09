/**
 * FinanceGest - dashboard.js
 * Nivel 4: WebSocket para atualizacao assincrona do saldo em tempo real.
 * Tambem gerencia o formulario rapido de transacoes.
 */

'use strict';

/* ─── WebSocket (Nivel 4) ─────────────────────────────── */
(function conectarWS() {
  var dot   = document.getElementById('wsDot');
  var label = document.getElementById('wsLabel');
  var proto = location.protocol === 'https:' ? 'wss' : 'ws';
  var url   = proto + '://' + location.host + '/ws';
  var ws;

  function conectar() {
    ws = new WebSocket(url);

    ws.onopen = function () {
      dot.classList.add('on');
      label.textContent = 'Tempo real ativo';
    };

    ws.onmessage = function (evt) {
      try {
        var data = JSON.parse(evt.data);
        if (data.type === 'balance_update' && data.username === WS_USERNAME) {
          atualizarSaldo(data);
        }
      } catch (e) {}
    };

    ws.onclose = function () {
      dot.classList.remove('on');
      label.textContent = 'Reconectando...';
      setTimeout(conectar, 3000);
    };

    ws.onerror = function () { ws.close(); };
  }

  function atualizarSaldo(data) {
    var elSaldo    = document.getElementById('saldo');
    var elReceitas = document.getElementById('receitas');
    var elDespesas = document.getElementById('despesas');

    if (elSaldo) {
      var span = elSaldo.querySelector('span') || elSaldo;
      span.textContent = formatBRL(data.saldo);
      span.className   = data.saldo >= 0 ? 'val-pos' : 'val-neg';
      // Animacao de destaque ao atualizar
      elSaldo.style.transition = 'transform .15s';
      elSaldo.style.transform  = 'scale(1.08)';
      setTimeout(function () { elSaldo.style.transform = ''; }, 200);
    }
    if (elReceitas) elReceitas.textContent = formatBRL(data.receitas);
    if (elDespesas) elDespesas.textContent = formatBRL(data.despesas);
  }

  conectar();
})();

/* ─── Formulario rapido: troca categorias ao mudar tipo ─ */
function updateQuickCats() {
  var tipo  = document.getElementById('qTipo').value;
  var catEl = document.getElementById('qCat');
  var cats  = tipo === 'receita' ? CAT_RECEITA : CAT_DESPESA;
  catEl.innerHTML = '';
  cats.forEach(function (c) {
    var opt = document.createElement('option');
    opt.value = c; opt.textContent = c;
    catEl.appendChild(opt);
  });
}

document.addEventListener('DOMContentLoaded', function () {
  updateQuickCats();
  // Atualiza categorias quando tipo mudar
  var qTipo = document.getElementById('qTipo');
  if (qTipo) qTipo.addEventListener('change', updateQuickCats);
});
