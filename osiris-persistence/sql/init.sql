/* TABLE CREATION */
/* CONFIG */
create table Config (clave varchar(40) not null, 
                     valor varchar(255) not null)
;
alter table Config add primary key (clave)
;
/* SEQUENCE */
create table SEQUENCE (SEQ_NAME varchar(50) not null,
                       SEQ_COUNT bigint not null)
;
alter table SEQUENCE add primary key (SEQ_NAME)
;
/* PERSONA */
create table Persona (id int not null, 
                      nombre varchar(40) not null, 
                      DTYPE varchar(31) not null, 
                      condicionIVA int not null)
;
insert into SEQUENCE
select 'Persona', 0
;
alter table Persona add primary key (id)
;
/* PERSONAFISICA */
create table PersonaFisica (id int not null, 
                            dni int not null, 
                            sexo int not null, 
                            fechaNacimiento datetime not null)
;
alter table PersonaFisica add primary key (id)
;
alter table PersonaFisica add constraint FK_PersonaFisica_Persona foreign key (id) references Persona (id)
;
/* PERSONAJURIDICA */
create table PersonaJuridica (id int not null, 
                              razonSocial varchar(40) not null, 
                              cuit varchar(13) not null)
;
alter table PersonaJuridica add primary key (id)
;
alter table PersonaJuridica add constraint FK_PersonaJuridica_Persona foreign key (id) references Persona (id)
;
/* SECURITYOBJECT */
create table SecurityObject (id int not null,
                             nombre varchar(20) not null,
                             DTYPE varchar(31) not null)
;
alter table SecurityObject add primary key (id)
;
insert into SEQUENCE
select 'SecurityObject', 0
;
/* SYSTEMGROUP */
create table SystemGroup (id int not null,
                          descripcion varchar(255) null)
;
alter table SystemGroup add primary key (id)
;
alter table SystemGroup add constraint FK_SystemGroup_SecurityObject foreign key (id) references SecurityObject (id)
;
/* SYSTEMROLE */
create table SystemRole (id int not null,
                         descripcion varchar(255) null)
;
alter table SystemRole add primary key (id)
;
alter table SystemRole add constraint FK_SystemRole_SecurityObject foreign key (id) references SecurityObject (id)
;
/* SYSTEMUSER */
create table SystemUser (id int not null,
                         theme varchar(40) null, 
                         canChangeTheme bit not null, 
                         canSeeConnectedUsers bit not null, 
                         canSendMessages bit not null, 
                         canDisconnectUser bit not null, 
                         sessionTimeout tinyint not null, 
                         canChangeSessionTimeout bit not null)
;
alter table SystemUser add primary key (id)
;
alter table SystemUser add constraint FK_SystemUser_SecurityObject foreign key (id) references SecurityObject (id)
;
/* SYSTEMUSERPERSONAFISICA */
create table SystemUserPersonaFisica (id int not null, 
                                      personaFisica_id int not null)
;
alter table SystemUserPersonaFisica add primary key (id)
;
alter table SystemUserPersonaFisica add constraint FK_SystemUserPersonaFisica_SystemUser foreign key (id) references SystemUser (id)
;
alter table SystemUserPersonaFisica add constraint FK_SystemUserPersonaFisica_PersonaFisica foreign key (personaFisica_id) references PersonaFisica (id)
;
/* SYSTEMUSERADMIN */
create table SystemUserAdmin (id int not null)
;
alter table SystemUserAdmin add primary key (id)
;
alter table SystemUserAdmin add constraint FK_SystemUserAdmin_SystemUser foreign key (id) references SystemUser (id)
;
/* SYSTEMUSERPASSWORD */
create table SystemUserPassword (id int not null,
                                 systemUser_id int not null,
                                 fechaDesde datetime not null,
                                 fechaHasta datetime null,
                                 password varchar(60) not null)
;
alter table SystemUserPassword add primary key (id)
;
alter table SystemUserPassword add constraint FK_SystemUserPassword_SystemUser foreign key (systemUser_id) references SystemUser (id)
;
insert into SEQUENCE
select 'SystemUserPassword', 0
;
/* SYSTEMGROUPROLES */
create table SystemGroupRoles (id int not null,
                               systemGroup_id int not null,
                               systemRole_id int not null)
;
alter table SystemGroupRoles add primary key (id)
;
alter table SystemGroupRoles add constraint FK_SystemGroupRoles_SystemGroup foreign key (systemGroup_id) references SystemGroup (id)
;
alter table SystemGroupRoles add constraint FK_SystemGroupRoles_SystemRole foreign key (systemRole_id) references SystemRole (id)
;
insert into SEQUENCE
select 'SystemGroupRoles', 0
;
/* SYSTEMROLEUSERS */
create table SystemRoleUsers (id int not null,
                              systemRole_id int not null,
                              systemUser_id int not null)
;
alter table SystemRoleUsers add primary key (id)
;
alter table SystemRoleUsers add constraint FK_SystemRoleUsers_SystemRole foreign key (systemRole_id) references SystemRole (id)
;
alter table SystemRoleUsers add constraint FK_SystemRoleUsers_SystemUser foreign key (systemUser_id) references SystemUser (id)
;
insert into SEQUENCE
select 'SystemRoleUsers', 0
;
/* SYSTEMOPTION */
create table SystemOption (id int not null,
                           codigo varchar(10) not null,
                           titulo varchar(20) not null,
                           descripcion varchar(255) not null,
                           parent_id int null,
                           url varchar(255) null,
                           orden int not null)
;
alter table SystemOption add primary key (id)
;
alter table SystemOption add constraint FK_SystemOption_SystemOption foreign key (parent_id) references SystemOption (id)
;
insert into SEQUENCE
select 'SystemOption', 0
;
/* SYSTEMOPTIONSECURITY */
create table SystemOptionSecurity (id int not null,
                                   optionCode varchar(10) not null,
                                   optionTitle varchar(20) not null)
;
alter table SystemOptionSecurity add primary key (id)
;
insert into SEQUENCE
select 'SystemOptionSecurity', 0
;
/* SYSTEMOPTIONSECURITYOPTIONS */
create table SystemOptionSecurityOption (id int not null,
                                          systemOption_id int not null,
                                          systemOptionSecurity_id int not null)
;
alter table SystemOptionSecurityOption add primary key (id)
;
alter table SystemOptionSecurityOption add constraint FK_SystemOptionSecurityOption_SystemOption foreign key (systemOption_id) references SystemOption (id)
;
alter table SystemOptionSecurityOption add constraint FK_SystemOptionSecurityOption_SystemOptionSecurity foreign key (systemOptionSecurity_id) references SystemOptionSecurity (id)
;
insert into SEQUENCE
select 'SystemOptionSecurityOption', 0
;
/* SYSTEMOPTIONSECURITYVALUE */
create table SystemOptionSecurityValue (id int not null,
                                        securityObject_id int not null,
                                        systemOptionSecurityOption_id int not null,
                                        canDoIt bit not null, 
                                        inheritedFrom int null)
;
alter table SystemOptionSecurityValue add primary key (id)
;
alter table SystemOptionSecurityValue add constraint FK_SystemOptionSecurityValue_SecurityObject foreign key (securityObject_id) references SecurityObject (id)
;
alter table SystemOptionSecurityValue add constraint FK_SystemOptionSecurityValue_SystemOptionSecurityOption foreign key (systemOptionSecurityOption_id) references SystemOptionSecurityOption (id)
;
alter table SystemOptionSecurityValue add constraint FK_SystemOptionSecurityValue_SystemOptionSecurityValue foreign key (inheritedFrom) references SystemOptionSecurityValue (id)
;
insert into SEQUENCE
select 'SystemOptionSecurityValue', 0
;
/* PAIS */
create table Pais (id int not null, 
                   nombre varchar(40) not null,
                   predeterminado bit not null)
;
alter table Pais add primary key (id)
;
insert into SEQUENCE
select 'Pais', 0
;
/* PROVINCIA */
create table Provincia (id int not null, 
                        nombre varchar(40) not null, 
                        pais_id int not null, 
                        predeterminada bit not null)
;
alter table Provincia add primary key (id)
;
alter table Provincia add constraint FK_Provincia_Pais foreign key (pais_id) references Pais (id)
;
insert into SEQUENCE
select 'Provincia', 0
;
/* LOCALIDAD */
create table Localidad (id int not null, 
                        nombre varchar(40) not null, 
                        provincia_id int not null, 
                        predeterminada bit not null)
;
alter table Localidad add primary key (id)
;
alter table Localidad add constraint FK_Localidad_Provincia foreign key (provincia_id) references Provincia (id)
;
insert into SEQUENCE
select 'Localidad', 0
;
/* CALLE */
create table Calle (id int not null, 
                    nombre varchar(40) not null, 
                    localidad_id int not null)
;
alter table Calle add primary key (id)
;
alter table Calle add constraint FK_Calle_Localidad foreign key (localidad_id) references Localidad (id)
;
insert into SEQUENCE
select 'Calle', 0
;
/* DIRECCION */
create table Direccion (id int not null, 
                        codigoPostal varchar(8) not null,
                        observaciones varchar(255) null, 
                        persona_id int not null, 
                        tipoDireccion int not null,
                        DTYPE varchar(31) not null)
;
alter table Direccion add primary key (id)
;
alter table Direccion add constraint FK_Direccion_Persona foreign key (persona_id) references Persona (id)
;
insert into SEQUENCE
select 'Direccion', 0
;
/* DIRECCIONTIPIFICADA */
create table DireccionTipificada (id int not null, 
                                  calle_id int not null, 
                                  numero varchar(10) not null, 
                                  unidadFuncional varchar(10) null)
;
alter table DireccionTipificada add primary key (id)
;
alter table DireccionTipificada add constraint FK_DireccionTipificada_Direccion foreign key (id) references Direccion (id)
;
alter table DireccionTipificada add constraint FK_DireccionTipificada_Calle foreign key (calle_id) references Calle (id)
;
/* DIRECCIONSINCALLE */
create table DireccionSinCalle (id int not null, 
                                localidad_id int not null, 
                                direccion varchar(255) not null)
;
alter table DireccionSinCalle add primary key (id)
;
alter table DireccionSinCalle add constraint FK_DireccionSinCalle_Direccion foreign key (id) references Direccion (id)
;
alter table DireccionSinCalle add constraint FK_DireccionSinCalle_Localidad foreign key (localidad_id) references Localidad (id)
;
/* DIRECCIONINTERNACIONAL */
create table DireccionInternacional (id int not null, 
                                     pais_id int not null, 
                                     provincia varchar(40) not null, 
                                     localidad varchar(40) not null, 
                                     direccion varchar(255) not null)
;
alter table DireccionInternacional add primary key (id)
;
alter table DireccionInternacional add constraint FK_DireccionInternacional_Direccion foreign key (id) references Direccion (id)
;
alter table DireccionInternacional add constraint FK_DireccionInternacional_Pais foreign key (pais_id) references Pais (id)
;
/* CONTACTOPERSONA */
create table ContactoPersona (id int not null, 
                              tipo int not null, 
                              persona_id int not null, 
                              DTYPE varchar(31) not null)
;
alter table ContactoPersona add primary key (id)
;
alter table ContactoPersona add constraint FK_ContactoPersona_Persona foreign key (persona_id) references Persona (id)
;
insert into SEQUENCE
select 'ContactoPersona', 0
;
/* EMAILPERSONA */
create table EmailPersona (id int not null, 
                           email varchar(40) not null)
;
alter table EmailPersona add primary key (id)
;
alter table EmailPersona add constraint FK_EmailPersona_ContactoPersona foreign key (id) references ContactoPersona (id)
;
/* TELEFONOPERSONA */
create table TelefonoPersona (id int not null, 
                              telefono varchar(40) not null)
;
alter table TelefonoPersona add primary key (id)
;
alter table TelefonoPersona add constraint FK_TelefonoPersona_ContactoPersona foreign key (id) references ContactoPersona (id)
;
/* WEBPERSONA */
create table WebPersona (id int not null, 
                         url varchar(40) not null)
;
alter table WebPersona add primary key (id)
;
alter table WebPersona add constraint FK_WebPersona_ContactoPersona foreign key (id) references ContactoPersona (id)
;
/* EMPLEADO */
create table Empleado (id int not null, 
                       personaFisica_id int not null, 
                       limiteAdelantos decimal(8, 2) not null)
;
alter table Empleado add primary key (id)
;
alter table Empleado add constraint FK_Empleado_PersonaFisica foreign key (personaFisica_id) references PersonaFisica (id)
;
insert into SEQUENCE
select 'Empleado', 0
;
/* CLIENTE */
create table Cliente (id int not null, 
                      persona_id int not null, 
                      limiteDeuda decimal(8, 2) not null, 
                      diasDeuda smallint not null, 
                      empleado_id int null)
;
alter table Cliente add primary key (id)
;
alter table Cliente add constraint FK_Cliente_Persona foreign key (persona_id) references Persona (id)
;
alter table Cliente add constraint FK_Cliente_Empleado foreign key (empleado_id) references Empleado (id)
;
insert into SEQUENCE
select 'Cliente', 0
;
/* PROVEEDOR */
create table Proveedor (id int not null, 
                      personaJuridica_id int not null, 
                      limiteDeuda decimal(8, 2) not null, 
                      diasDeuda smallint not null, 
                      empleado_id int null)
;
alter table Proveedor add primary key (id)
;
alter table Proveedor add constraint FK_Proveedor_PersonaJuridica foreign key (personaJuridica_id) references PersonaJuridica (id)
;
alter table Proveedor add constraint FK_Proveedor_Empleado foreign key (empleado_id) references Empleado (id)
;
insert into SEQUENCE
select 'Proveedor', 0
;
/* SOCIO */
create table Socio (id int not null, 
                      persona_id int not null, 
                      porcentaje tinyint not null)
;
alter table Socio add primary key (id)
;
alter table Socio add constraint FK_Socio_Persona foreign key (persona_id) references Persona (id)
;
insert into SEQUENCE
select 'Socio', 0
;

/* CONFIGURATION DATA */
insert into Config
select 'app.home.url', '/osiris/faces/index.xhtml'
;
insert into Config
select 'app.title', 'osiris'
;
insert into Config
select 'persona.profiles', 'Empleado|Cliente|Proveedor|Socio'
;
insert into Config
select 'persona.profiles.empleado.bean', 'ar.com.zir.osiris.web.app.personas.EmpleadoBean'
;
insert into Config
select 'persona.profiles.cliente.bean', 'ar.com.zir.osiris.web.app.personas.ClienteBean'
;
insert into Config
select 'persona.profiles.proveedor.bean', 'ar.com.zir.osiris.web.app.personas.ProveedorBean'
;
insert into Config
select 'persona.profiles.socio.bean', 'ar.com.zir.osiris.web.app.personas.SocioBean'
;
/* SECURITY DATA */
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (1, 'read', 'Leer')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (2, 'create', 'Crear')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (3, 'update', 'Actualizar')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (4, 'delete', 'Eliminar')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (5, 'adminCli', 'Adm. Clientes')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (6, 'adminProv', 'Adm. Proveedores')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (7, 'adminEmp', 'Adm. Empleados')
;
insert into SystemOptionSecurity (id, optionCode, optionTitle)
values (8, 'adminSoc', 'Adm. Socios')
;
update SEQUENCE set SEQ_COUNT = 8 where SEQ_NAME = 'SystemOptionSecurity'
;
insert into SecurityObject (id, nombre, dtype)
values (1, 'ADMIN', 'SystemUserAdmin')
;
update SEQUENCE set SEQ_COUNT = 1 where SEQ_NAME = 'SecurityObject'
;
insert into SystemUser (id, theme, canChangeTheme, canSeeConnectedUsers, canSendMessages, canDisconnectUser, sessionTimeout, canChangeSessionTimeout)
values (1, 'aristo', 1, 1, 1, 1, 5, 1)
;
insert into SystemUserAdmin (id)
values (1)
;
insert into SystemUserPassword (id, systemUser_id, fechaDesde, fechaHasta, password)
values (1, 1, CURRENT_TIMESTAMP(), null, '65a368f66ad6b9ee45263577713d8a95')
;
update SEQUENCE set SEQ_COUNT = 1 where SEQ_NAME = 'SystemUserPassword'
;
/* SYSTEM OPTIONS DATA */
insert into SystemOption
select 1, 'SEGURIDAD', 'Seguridad', 'Configuración de Seguridad', null, null, 10
;
insert into SystemOption
select 2, 'USUARIO', 'Usuarios', 'ABM de Usuarios', 1, '/faces/seguridad/usuarios.xhtml', 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 1, 2, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 1, 1, 1, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 2, 2, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 2, 1, 2, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 3, 2, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 3, 1, 3, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 4, 2, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 4, 1, 4, 1
;
insert into SystemOption
select 3, 'ROL', 'Roles', 'ABM de Roles', 1, '/faces/seguridad/roles.xhtml', 2
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 5, 3, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 5, 1, 5, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 6, 3, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 6, 1, 6, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 7, 3, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 7, 1, 7, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 8, 3, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 8, 1, 8, 1
;
insert into SystemOption
select 4, 'GRUPO', 'Grupos', 'ABM de Grupos', 1, '/faces/seguridad/grupos.xhtml', 3
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 9, 4, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 9, 1, 9, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 10, 4, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 10, 1, 10, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 11, 4, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 11, 1, 11, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 12, 4, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 12, 1, 12, 1
;
insert into SystemOption
select 5, 'PERSONAS', 'Personas', 'Configuración de Personas', null, null, 2
;
insert into SystemOption
select 6, 'PERSONA', 'Personas', 'ABM de Personas', 5, '/faces/personas/personas.xhtml', 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 13, 6, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 13, 1, 13, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 14, 6, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 14, 1, 14, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 15, 6, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 15, 1, 15, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 16, 6, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 16, 1, 16, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 33, 6, 5
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 33, 1, 33, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 34, 6, 6
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 34, 1, 34, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 35, 6, 7
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 35, 1, 35, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 36, 6, 8
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 36, 1, 36, 1
;
insert into SystemOption
select 7, 'CONFIG', 'Configuración', 'Configuración General', null, null, 1
;
insert into SystemOption
select 8, 'PAIS', 'Países', 'ABM de Países', 7, '/faces/configuracion/paises.xhtml', 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 17, 8, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 17, 1, 17, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 18, 8, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 18, 1, 18, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 19, 8, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 19, 1, 19, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 20, 8, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 20, 1, 20, 1
;
insert into SystemOption
select 9, 'PROVINCIA', 'Provincias', 'ABM de Provincias', 7, '/faces/configuracion/provincias.xhtml', 2
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 21, 9, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 21, 1, 21, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 22, 9, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 22, 1, 22, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 23, 9, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 23, 1, 23, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 24, 9, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 24, 1, 24, 1
;
insert into SystemOption
select 10, 'LOCALIDAD', 'Localidades', 'ABM de Localidades', 7, '/faces/configuracion/localidades.xhtml', 3
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 25, 10, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 25, 1, 25, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 26, 10, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 26, 1, 26, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 27, 10, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 27, 1, 27, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 28, 10, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 28, 1, 28, 1
;
insert into SystemOption
select 11, 'CALLE', 'Calles', 'ABM de Calles', 7, '/faces/configuracion/calles.xhtml', 4
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 29, 11, 1
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 29, 1, 29, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 30, 11, 2
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 30, 1, 30, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 31, 11, 3
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 31, 1, 31, 1
;
insert into SystemOptionSecurityOption (id, systemOption_id, systemOptionSecurity_id)
select 32, 11, 4
;
insert into SystemOptionSecurityValue (id, securityObject_id, systemOptionSecurityOption_id, canDoIt)
select 32, 1, 32, 1
;
update SEQUENCE set SEQ_COUNT = 11 where SEQ_NAME = 'SystemOption'
;
update SEQUENCE set SEQ_COUNT = 36 where SEQ_NAME = 'SystemOptionSecurityOption'
;
update SEQUENCE set SEQ_COUNT = 36 where SEQ_NAME = 'SystemOptionSecurityValue'
;


select * from systemoptionsecurityoption where systemoptionsecurity_id > 4

delete from systemoptionsecurityoption where id = 33

alter table Config modify clave varchar(40) not null