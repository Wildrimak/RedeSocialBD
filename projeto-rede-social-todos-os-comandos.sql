create table usuario(
	id_usuario serial not null,
	e_mail varchar(100) not null,
	senha varchar(50) not null,
	username varchar(50) not null,
	telefone varchar(20),
	nascimento date,
	constraint pk_usuario primary key(id_usuario)
);

ALTER TABLE usuario ADD CONSTRAINT unico_email UNIQUE (e_mail);
ALTER TABLE usuario ADD CONSTRAINT unico_username UNIQUE (username);

insert into usuario values (0, 'DELETADO@DELETADO.com', 'DELETADO7687', 'DELETADO', null, null);

insert into usuario values(default, 'wildrimak@outlook.com', 'Root',
'wildrimak', '+55 86 9 9810-0097', '1997-07-12');

insert into usuario values(default, 'marle@gmail.com', 'chrono',
'nadia', '', '980-05-10');

insert into usuario values(default, 'lucca@gmail.com', 'chrono',
'lucca', '', '980-03-12');

insert into usuario values(default, 'robo@gmail.com', 'lucca',
'r66y', '', '1980-03-12');

insert into usuario values(default, 'chrono@gmail.com', 'marle',
'chrono', null, '980-01-16');

insert into usuario values(default, 'lara@gmail.com', '67%1',
'lara', '+55 86 9 9190-0101', '1998-09-12');

insert into usuario values(default, 'welton@gmail.com', 'kmzau',
'welton', '+55 88 9 9440-0302', '1991-05-29');

insert into usuario values(default, 'fabricio@gmail.com', 'dbk*(Y)',
'fabricio', '+55 86 9 9956-7186', '1994-07-19');

delete from usuario where id_usuario = 9 or id_usuario = 10 or id_usuario = 11;

select * from usuario;

create table grupo(
	id_grupo serial not null,
	nome varchar(50) not null,
	data_criacao date not null,
	usuario_criador_do_grupo int not null,
	constraint pk_id_grupo primary key(id_grupo),
	constraint fk_usuario_criador_do_grupo foreign key(usuario_criador_do_grupo)
	references usuario(id_usuario)
);

insert into grupo values(default, 'Familia Chrono Trigger', 'now', 5);
insert into grupo values(default, 'Associados a Wildrimak', 'now', 1);
insert into grupo values(default, 'As Meninas Super Poderosas', 'now', 6);
select * from grupo;

create table participante_do_grupo(
	usuario_participante int not null,
	grupo_id_grupo int not null,
	constraint fk_usuario_participante_do_grupo
		foreign key(usuario_participante)
			references usuario(id_usuario),
	constraint fk_grupo_id_grupo foreign key(grupo_id_grupo)
		references grupo(id_grupo),
	constraint pk_participante_do_grupo
		primary key(usuario_participante, grupo_id_grupo)
);

insert into participante_do_grupo values (2, 1);
insert into participante_do_grupo values (3, 1);
insert into participante_do_grupo values (4, 1);
insert into participante_do_grupo values (5, 1);
insert into participante_do_grupo values (1, 2);
insert into participante_do_grupo values (6, 2);
insert into participante_do_grupo values (7, 2);
insert into participante_do_grupo values (8, 2);
/*
insert into participante_do_grupo values (2, 3);
insert into participante_do_grupo values (3, 3);
insert into participante_do_grupo values (6, 3);
*/

select * from participante_do_grupo;

create table mensagem_do_grupo(
	id_mensagem_do_grupo serial not null,
	participante_do_grupo_usuario_participante int not null,
	participante_do_grupo_id_grupo int not null,
	texto varchar(30000) not null,
	momento timestamp not null,
	constraint pk_id_mensagem_do_grupo
		primary key(id_mensagem_do_grupo),
	constraint fk_participante_usuario_na_mensagem_do_grupo
		foreign key(participante_do_grupo_usuario_participante, participante_do_grupo_id_grupo)
			references participante_do_grupo(usuario_participante, grupo_id_grupo)
);

alter table mensagem_do_grupo add column quem_mandou_a_mensagem varchar(50)
select * from mensagem_do_grupo;

insert into mensagem_do_grupo
	values (default, 1, 2, 'Oi gente meu nome é Wildrimak e eu criei esse grupo para passar informações importantes para vocês sobre jogos', 'now');
insert into mensagem_do_grupo
	values (default, 6, 2, 'Que nome de grupo tosco kkkkkkkkkkkkk', 'now');
insert into mensagem_do_grupo
	values (default, 7, 2, 'Pois é tinha que ser algo mais realista', 'now');
insert into mensagem_do_grupo
	values (default, 8, 2, 'Vou nem dizer nada...', 'now');
insert into mensagem_do_grupo
	values (default, 2, 1, 'Oi gente!!!', 'now');
insert into mensagem_do_grupo
	values (default, 3, 1, 'Marle que porra é essa... kkkkkk', 'now');
insert into mensagem_do_grupo
	values (default, 4, 1, 'Eu gostei!', 'now');
insert into mensagem_do_grupo
	values (default, 5, 1, 'Nada a comentar', 'now');
/*
insert into mensagem_do_grupo
	values (default, 2, 3, 'oi meninas', 'now');
insert into mensagem_do_grupo
	values (default, 3, 3, 'oi marle de novo?', 'now');
insert into mensagem_do_grupo
	values (default, 6, 3, 'nossa...', 'now');
*/

insert into mensagem_do_grupo
	values (default, 2, 3, 'booo! olha quem apareceu!', 'now');

select * from mensagem_do_grupo;

create table contato(
	eu int not null,
	ele int not null,
	nome varchar(50),
	constraint fk_eu foreign key(eu) references usuario(id_usuario),
	constraint fk_ele foreign key(ele) references usuario(id_usuario),
	constraint pk_contato primary key(eu, ele)
);

insert into contato values(1, 6, 'Lara Vaca');
insert into contato values(1, 7, 'Welton');
insert into contato values(1, 8, 'Fabricio');
insert into contato values(2, 3, 'Lucca');
insert into contato values(2, 4, 'Robo');
insert into contato values(2, 5, 'Love');
insert into contato values(4, 3, 'Lucca Mother');
select * from contato;

create table mensagem(
	id_mensagem serial not null,
	texto varchar(10000) not null,
	momento timestamp not null,
	usuario_remetente int not null,
	usuario_destinatario int not null,
	constraint pk_mensagem primary key(id_mensagem),
	constraint fk_usuario_remetente foreign key(usuario_remetente)
		references usuario(id_usuario),
	constraint fk_usuario_destinatario foreign key(usuario_destinatario)
		references usuario(id_usuario)
);

insert into mensagem 
	values(default, 'E ai  trouxa kkkkk', 'now', 1, 6);
insert into mensagem 
	values(default, 'Oi outro trouxa kkkkk', 'now', 6, 1);

select * from mensagem;

create table status(
	id_status serial not null,
	mensagem varchar(200) not null,
	data_status timestamp not null,
	imagem oid,
	usuario_id_usuario int not null,
	constraint pk_id_status primary key(id_status),
	constraint fk_usuario foreign key(usuario_id_usuario)
		references usuario(id_usuario)
);

insert into status values (default, 'Huhauahuahauahua', 'now', null, 1);
select * from status;

create table loja_virtual(
	id_loja_virtual serial not null,
	nome varchar(500) not null,
	usuario_criador_da_loja int not null,
	slogan varchar(1000) not null,
	razao_social varchar(10000) not null,
	foto_da_loja oid,
	site varchar(3000),
	endereco_fisico varchar(50000),
	constraint pk_id_loja_virtual primary key(id_loja_virtual),
	constraint fk_usuario_criador_da_loja foreign key(usuario_criador_da_loja) references usuario(id_usuario)
);

insert into loja_virtual 
	values(default, 'Quintadinha do Chrono', 5, 'Seja Forte Aqui!', 
	'Espadas, Acessorios, Poções e Armaduras encontram-se aqui!', null, null, 
	'Governo Guardia, Próximo a feira do milênio e ao norte da prefeitura');

insert into loja_virtual 
	values(default, 'Desenvolvedor Web e Android Aqui!', 1, 'Desenvolvedor de Qualidade e Barato Aqui!', 
	'Sites e Aplicativos Androids ', null, null, null);

insert into loja_virtual 
	values(default, 'Lara Games', 6, 'Jogos Antigos Aqui!', 
	'Jogos de PS2, Nintendo DS, Super Nintendo entre outros se encontra aqui!', null, null, null);
		
select * from loja_virtual;

create table produto(
	id_produto serial not null,
	nome varchar(500) not null,
	preco float not null,
	quantidade int not null,
	descricao varchar(1000) not null,
	foto_do_produto oid,
	loja_do_produto int not null,
	constraint pk_id_produto primary key(id_produto),
	constraint fk_loja_do_produto foreign key(loja_do_produto) references loja_virtual(id_loja_virtual)
);

insert into produto values(default, 'pocão simples', 50.00, 99, 'Recupere 50 pontos de vida', null, 1);
insert into produto values(default, 'espada de madeira', 1.99, 3, 'Aumente 1 ponto de força', null, 1);
insert into produto values(default, 'espada de madeira', 1.99, 3, 'Aumente 1 ponto de força', null, 1);
insert into produto values(default, 'revolver de luz', 9999.00, 1, 'Aumente sua mira e força em 100%', null, 1);

select * from produto;

create table compra(
	id_compra serial not null,
	usuario_que_compra int not null,
	preco_total float not null,
	local_de_entrega varchar(20000) not null,
	data_compra timestamp not null,
	constraint pk_id_compra primary key(id_compra),
	constraint fk_usuario_que_compra foreign key(usuario_que_compra) references usuario(id_usuario)
);

select * from compra;

create table item_compra(
	produto int not null,
	compra int not null,
	valor_item float not null,
	quantidade_itens_comprados int not null,
	constraint fk_produto foreign key(produto) references produto(id_produto),
	constraint fk_compra foreign key(compra) references compra(id_compra),
	constraint pk_item_compra primary key(produto, compra)
);

select * from item_compra;

create table servico(
	id_servico serial not null,
	nome varchar(30000) not null,
	preco float not null,
	periodo_de_duracao_em_dias int not null,
	descricao varchar(10000),
	loja_do_servico int not null,
	constraint pk_id_servico primary key(id_servico),
	constraint fk_loja_do_servico foreign key(loja_do_servico) references loja_virtual(id_loja_virtual)
);

select * from servico;

create table contrata(
	usuario int not null,
	servico int not null,
	data_contrato timestamp not null,
	valor_contratado float not null,
	constraint fk_usuario foreign key(usuario) references usuario(id_usuario),
	constraint fk_servico foreign key(servico) references servico(id_servico),
	constraint pk_contrata primary key(usuario, servico)
);

select * from contrata;
