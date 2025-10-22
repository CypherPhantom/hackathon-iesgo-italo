use prova1;

insert into clientes (nome, endereco, telefone)
VALUES('Daniel Amorim', 'formosinha, formosa', '61988887777'),
('Joao Neto', 'centro, formosa', '61977776666'),
('Kevin Garza', 'praça, formosa', '61966665555');
select * from clientes;

insert into entregadores (nome, cnh, modelo_veiculo)
VALUES('Vitor jr', '123456789', 'Moto Honda'),
('Luan Calazans', '987654321', 'Moto Yamaha');
select * from entregadores;

insert into tipo_cardapio (tipo_cardapio) 
VALUES ('Italiana'), 
('Pizzaria'), 
('Japonesa');
select * from tipo_cardapio;

insert into restaurntes (nome) 
VALUES ('restaurante cantina italiana'), 
('Pizza do Bairro'), 
('Sushi Imperial');
select * from restaurntes;

insert into itens_cardapio (nome, preco, descricao, id_tipo_cardapio)
VALUES('Lasanha', 35.50, 'Massa fresca com molho bolonhesa', 1),
('nhoque', 32.00, 'Nhoque de batata com molho de tomate', 1),
('Pizza Calabresa', 42.00, 'Molho, mussarela, calabresa e cebola', 2),
('Pizza Portguuesa', 51.00, 'Molho, mussarela, ovo, pimentao', 2),
('Combinado hot', 65.00, 'salmo frito',3);
select * from itens_cardapio;

insert into restaurante_cardapio (id_restaurante, id_cardapio) 
VALUES(1, 1), 
(2, 2),
(3, 3);
select * from restaurante_cardapio;

insert into pedido (id_cliente, id_restaurante, id_entregador, data_pedido, status_entrega, preco_entrega) 
VALUES(1, 1, 1, '2025-09-20', 'Entregue', 7.00),
(2, 2, 2, '2025-09-21', 'Entregue', 8.50),
(3, 3, 1, '2025-09-22', 'Entregue', 7.00), 
(1, 2, 2, '2025-09-23', 'Entregue', 8.50),
(2, 1, 1, '2025-09-24', 'Entregue', 7.00), 
(1, 1, 2, '2025-09-25', 'Entregue', 7.00); 


insert into avaliacao (id_cliente, id_pedido, avaliacap_pedido, avaliacao_entrega) 
VALUES(1, 1, '5', '4'),
(2, 2, '4', '5'), 
(3, 3, '3', '3'), 
(1, 4, '5', '5'); 




