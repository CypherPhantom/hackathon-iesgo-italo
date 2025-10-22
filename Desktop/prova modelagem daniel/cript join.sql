use prova1;
SELECT 
    r.nome,
    COUNT(p.id_pedido) AS total_pedidos
FROM restaurntes r
JOIN pedido p ON r.id_restaurntes = p.id_restaurante
GROUP BY r.nome
ORDER BY total_pedidos DESC
LIMIT 1;

SELECT 
    c.nome,
    SUM(p.preco_entrega) AS total_gasto_entrega
FROM clientes c
JOIN pedido p ON c.id_clientes = p.id_cliente
GROUP BY c.nome
ORDER BY total_gasto_entrega DESC
LIMIT 1;


SELECT 
    i.nome,
    i.preco
FROM itens_cardapio i
JOIN tipo_cardapio tc ON i.id_tipo_cardapio = tc.id_tipo_cardapio
JOIN restaurante_cardapio rc ON tc.id_tipo_cardapio = rc.id_cardapio
JOIN restaurntes r ON rc.id_restaurante = r.id_restaurntes
WHERE r.nome = 'Pizza do Bairro' AND i.preco > 40.00;