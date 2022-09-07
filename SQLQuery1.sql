
--Creacion de tablas y base de datos
Create database BANCO

go

use BANCO

go
Create table CLIENTES(
dni int not null,
nombre varchar(50),
apellido varchar(50)
constraint pk_dni primary key (dni)
)

alter table clientes
add  baja_logica bit

go

create table TIPO_CUENTAS
(
id_tipo_cuenta int not null,
tipo varchar(70)
constraint pk_id_tipo_cuenta primary key(id_tipo_cuenta)
)


go

create table CUENTAS(
Cbu bigint not null,
dni int,
saldo money, 
id_tipo_cuenta int,
constraint pk_cbu primary key(cbu),
constraint fk_id_tipo_cuenta foreign key (id_tipo_cuenta) references TIPO_CUENTAS (id_tipo_cuenta),
constraint fk_dni foreign key (dni) references CLIENTES (dni)
)

alter table cuentas
add  baja_logica bit

insert into TIPO_CUENTAS values (1, 'Corriente')
insert into TIPO_CUENTAS values (2, 'Sueldo')
insert into TIPO_CUENTAS values (3, 'Ahorro')
insert into TIPO_CUENTAS values (4, 'Ahorro en USD')
insert into CLIENTES values (29388213, 'Juan', 'Gomez')
insert into CUENTAS values (123451,29388213,9231,2)


Select * from TIPO_CUENTAS

--Creacion de proc

--Carga de tabla auxiliar
CREATE PROCEDURE sp_return_table_aux
as 
select * from TIPO_CUENTAS


--carga de clientes
create proc sp_return_clientes
as 
select * from CLIENTES
 where baja_logica = 0

create proc sp_return_cuentas
as
select * from CUENTAS
where baja_logica = 0

create proc sp_search_cliente
	@dni int
as
select * from CLIENTES where dni = @dni



create proc sp_search_cuenta 
	@cbu int
as 
select * from CUENTAS where Cbu = @cbu

create proc sp_insert_cliente(

	@dni int,
	@nombre varchar(50),
	@apellido varchar(50))
as
	insert into CLIENTES(dni,nombre,apellido,baja_logica) values (@dni, @nombre, @apellido,0)

create procedure sp_insert_cuentas(
	@cbu bigint,
	@saldo money,
	@id_tipo_cuenta int,
	@dni int)
as 
	insert into CUENTAS (Cbu,saldo,id_tipo_cuenta,dni,baja_logica) values (@cbu,@saldo,@id_tipo_cuenta,@dni,0)

create procedure sp_update_clientes(
	@dni int,
	@nombre varchar(50),
	@apellido varchar(50))

	as
	update CLIENTES
	set  nombre = @nombre,
	apellido = @apellido
	where dni=@dni

create procedure sp_update_cuenta(
	@cbu int,
	@dni int,
	@saldo money,
	@id_tipo_cuenta int)
	as
	update CUENTAS
	set 
	dni =@dni,
	saldo = @saldo,
	id_tipo_cuenta = @id_tipo_cuenta
	where Cbu = @cbu



create procedure sp_delete_cliente(
	@dni int)
as	

	update CLIENTES
	set baja_logica = 1
	where dni=@dni



create procedure sp_delete_cuenta(
	@cbu int)
as 
	update CUENTAS
	set baja_logica = 1
	where Cbu=@cbu

create procedure sp_load_clientes

as 
select dni, str(dni)+SPACE(1)+nombre+SPACE(1)+apellido 'Cliente' from CLIENTES

select * 
from TIPO_CUENTAS


drop procedure sp_report

create procedure sp_report
as
select COUNT(c.Cbu),tc.tipo, cl.nombre 
from CUENTAS c
join TIPO_CUENTAS tc on c.id_tipo_cuenta = tc.id_tipo_cuenta
join CLIENTES cl on cl.dni = c.dni
group by c.Cbu,tc.tipo,cl.nombre

