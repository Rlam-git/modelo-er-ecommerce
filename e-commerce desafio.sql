-- Criação do banco de dados

create database if not exists ecommerce;
use ecommerce;

-- Criação das tabelas

create table if not exists cliente(
idCliente int auto_increment primary key,
nome varchar(45) not null,
email varchar(100) not null,
data_nascimento date not null,
cpf char(11) unique,
cnpj char(18) unique,
unique (email)
);

create table if not exists telefone(
idTelefone int auto_increment primary key,
idCliente int not null,
numero_telefone varchar(15) not null unique,
ddd char(3) not null,
constraint fk_cliente foreign key(idCliente) references cliente(idCliente)
);

create table if not exists endereco(
idEndereco int auto_increment primary key,
cep char(8) not null unique,
cidade varchar(25) not null,
bairro varchar(45) not null,
rua varchar(45) not null,
numero varchar(5) not null,
complemeto varchar(50)
);

create table if not exists endereco_cliente(
idEndereco int not null,
idCliente int not null,
constraint fk_telefone_endereco_cliente foreign key (idEndereco) references endereco(idEndereco),
constraint fk_cliente_endereco_cliente foreign key (idCliente) references cliente(idCliente),
primary key(idEndereco, idCliente)
);

create table  if not exists cartao (
  idCartao int auto_increment primary key,
  idCliente int not null,
  numero char(16) not null,
  data_validade date not null,
  bandeira varchar(15) not null,
  cvv char(3) not null,
  nome_cartao varchar(50),
  constraint fk_cliente_cartao foreign key(idCliente) references cliente(idCliente)
);

create table  if not exists produto(
idProduto int auto_increment primary key,
nome varchar(100) not null,
valor double not null,
descricao varchar(255)
);

create table  if not exists compra(
idCompra int auto_increment primary key,
data_compra date not null,
valor double(10,2) not null,
situacao varchar(15) not null
);

create table  if not exists produto_compra(
idCompra int not null,
idProduto int not null,
constraint fk_produto_produto_compra foreign key (idProduto) references produto(idProduto),
constraint fk_compra_produto_compra foreign key (idProduto) references produto(idProduto),
primary key(idCompra,idProduto)
);

create table  if not exists pagamento(
idPagamento int auto_increment primary key,
idCartao int not null,
data_pagamento datetime not null,
valor double(10,2) not null,
numero_parcela int not null default(01),
constraint fk_cartao_pagamento foreign key(idCartao) references cartao(idCartao)
);

create table  if not exists transportadora(
idtransportadora int auto_increment primary key,
nome varchar(50) not null,
cnpj char(12) not null
);

create table  if not exists tipo_remessa(
idTipo_remessa int auto_increment primary key,
descricao varchar(25) not null
);

create table  if not exists remessa(
idRemessa int auto_increment primary key,
idCompra int not null,
idTransportadora int not null,
idTipo_remessa int not null,
codigo_rastreio char(14) not null unique,
data_prevista date not null,
data_final date,
endereco varchar(100) not null,
valor double(10,2) not null,
constraint fk_idCompra_remessa foreign key(idCompra) references compra(idCompra),
constraint fk_idTransportadora_remessa foreign key(idTransportadora) references transportadora(idTransportadora),
constraint fk_idTipo_remessa_remessa foreign key(idTipo_remessa) references tipo_remessa(idTipo_remessa)
);

-- inserir dados nas tabelas

insert into cliente(nome,data_nascimento,email,cpf)
	values 
		('Felipe Kevin Marcos Pinto','1976-10-26','felipekevin@hotmail.com','98787770571'),
		('Raimunda Tatiane Juliana Moreira','1946-08-17','raimunda_moreira@arbitral.com@hotmail.com','49486881340'),
		('Giovanni Caio Severino Pereira','1971-10-17','giovanni_pereira@gmail.com.br','68173768749'),
		('Sueli Bianca Ferreira','1945-10-24','sueli-ferreira82@gmail.com.br','21306776570'),
		('Igor Henrique da Mota','1974-07-06','igor_henrique_damota@suplementototal.com.br','07643976481'),
		('Maitê Teresinha Rayssa Novaes','2006-09-02','maite_novaes@br.loreal.com','89910078481');

    
insert into telefone(idCliente,numero_telefone,ddd)
    values((select idCliente from cliente where cpf = '49486881340'),'997555845','061');
insert into telefone(idCliente,numero_telefone,ddd) 
	values((select idCliente from cliente where cpf = '98787770571'),'992109532','086');
insert into telefone(idCliente,numero_telefone,ddd) 
	values((select idCliente from cliente where cpf = '68173768749'),'995402831','083');
insert into telefone(idCliente,numero_telefone,ddd) 
	values((select idCliente from cliente where cpf = '21306776570'),'986017581','069');
insert into telefone(idCliente,numero_telefone,ddd) 
	values((select idCliente from cliente where cpf = '07643976481'),'991321051','031');
insert into telefone(idCliente,numero_telefone,ddd) 
	values((select idCliente from cliente where cpf = '89910078481'),'995159032','081');

           
    insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
    value ('58101525','Cabedelo','Poço','Rua Valdemar Melo de Brito','136','apt 120');
    insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
	value ('76912120','Ji-Paraná','Jardim Capelasso','Rua Maracanã','591','apt 320A');
    insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
    value ('32605610','Betim','Ponte Alta','Rua Ronnie Peterson','880','Sala 320');
    insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
	value ('50970230','Recife','Várzea','Rua Cônego José Fernandes Machado','201','Empresa Loreal');
	insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
	values ('72863537','Novo Gama','Alphavile Paiva','Quadra Quadra 18','593','Casa');    			
	insert into endereco(cep,cidade,bairro,rua,numero,complemeto) 
	values('58074685','João Pessoa','José Américo de Almeida','Rua Mário Santa Cruz Costa','550','Casa');

select * from endereco_cliente;
	insert into endereco_cliente(idEndereco,idCliente) 
		value((select idEndereco from endereco where cep = '72863537'), (select idCliente from cliente where cpf = '98787770571'));

	insert into endereco_cliente(idEndereco,idCliente)
		values((select idEndereco from endereco where cep = '58074685'), (select idCliente from cliente where cpf = '49486881340'));
	 
	insert into endereco_cliente(idEndereco,idCliente) 
		values((select idEndereco from endereco where cep = '58101525'), (select idCliente from cliente where cpf = '68173768749'));

	insert into endereco_cliente(idEndereco,idCliente) 
		values((select idEndereco from endereco where cep = '76912120'), (select idCliente from cliente where cpf = '21306776570'));

	insert into endereco_cliente(idEndereco,idCliente)
		values((select idEndereco from endereco where cep = '32605610'), (select idCliente from cliente where cpf = '07643976481'));
	 
	insert into endereco_cliente(idEndereco,idCliente) 
		values((select idEndereco from endereco where cep = '50970230'), (select idCliente from cliente where cpf = '89910078481'));


  insert into cartao(idCliente,numero,bandeira,cvv,nome_cartao,data_validade)
	values((select idCliente from cliente where cpf = '49486881340'),'5212421239360317','master','314','Felipe K Marcos Pinto','2026-10-21');
  insert into cartao(idCliente,numero,bandeira,cvv,nome_cartao,data_validade)
	values((select idCliente from cliente where cpf = '98787770571'),'5542596782985791','master','373','Raimunda T J Moreira','2026-01-21');
  insert into cartao(idCliente,numero,bandeira,cvv,nome_cartao,data_validade)
	values((select idCliente from cliente where cpf = '68173768749'),'4539402060389186','visa','580','Giovanni C S Pereira','2026-04-21');
    
  insert into produto(nome,valor,descricao)  values('Teclado',800,'Teclado mecanico gamer');
  insert into produto(nome,valor,descricao)  values('Monitor 35Pl',1500.00,'Monitor full hd');
  insert into produto(nome,valor,descricao)  values('Microfone',20.00,'c3tech');
  






