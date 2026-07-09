/**
 * FinanceGest - transacoes.js
 * CRUD client-side: filtro da tabela e troca de categorias.
 */

'use strict';

/** Atualiza opcoes de categoria conforme o tipo selecionado */
function updateCategorias() {
  var tipo  = document.getElementById('tipoSelect').value;
  var catEl = document.getElementById('categoriaSelect');
  var cats  = tipo === 'receita' ? CAT_RECEITA : CAT_DESPESA;
  catEl.innerHTML = '';
  cats.forEach(function (c) {
    var opt = document.createElement('option');
    opt.value = c; opt.textContent = c;
    catEl.appendChild(opt);
  });
}

/** Filtra linhas da tabela por texto e tipo */
function filterTable() {
  var busca  = document.getElementById('searchInput').value.toLowerCase();
  var tipo   = document.getElementById('tipoFilter').value;
  var rows   = document.querySelectorAll('#txTable tbody tr');
  var visiveis = 0;

  rows.forEach(function (row) {
    var texto    = row.textContent.toLowerCase();
    var rowTipo  = row.getAttribute('data-tipo');
    var okBusca  = texto.includes(busca);
    var okTipo   = !tipo || rowTipo === tipo;
    var visivel  = okBusca && okTipo;
    row.style.display = visivel ? '' : 'none';
    if (visivel) visiveis++;
  });

  var countEl = document.getElementById('tableCount');
  if (countEl) {
    countEl.textContent = visiveis + ' transaç' + (visiveis === 1 ? 'ão' : 'ões') + ' exibida' + (visiveis === 1 ? '' : 's');
  }
}

document.addEventListener('DOMContentLoaded', function () {
  filterTable(); // conta inicial
});
