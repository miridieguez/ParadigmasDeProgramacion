
% INFLUENCERS

% Modelado inicial

usuario(ana,youtube, 3000000).
usuario(ana,instagram, 2700000).
usuario(ana,tiktok, 1000000).
usuario(ana,twich, 2).

usuario(beto,youtube, 6000000).
usuario(beto,instagram, 1100000).
usuario(beto,twich, 120000).

usuario(cami,tiktok, 2000).

usuario(dani,youtube,1000000).

usuario(evelyn,instagram,1).

% 2) sobre los influencers:

% a) influencer/1 se cumple para un usuario que tiene más de 10.000 seguidores en total entre todas sus redes.
% nro magico    

requisitoSeguidores(influencer, 10000).

influencer(Usuario):-
    seguidoresTotales(Usuario, Seguidores),
    requisitoSeguidores(influencer, RequisitoInfluencer),
    Seguidores > RequisitoInfluencer.

seguidoresTotales(Usuario, Seguidores):-
    usuario(Usuario,_,_),
    findall( SeguidoresPorRed, usuario(Usuario, _, SeguidoresPorRed), ListaDeSeguidores),
    sum_list(ListaDeSeguidores, Seguidores).

% b) omnipresente/1 se cumple para un influencer si está en cada red que existe (se consideran como existentes aquellas redes en las que hay al menos un usuario).

omnipresente(Influencer):-
    influencer(Influencer),
    forall(existe(Redes), usuario(Influencer,Redes,_)).
    
existe(Red):-
    usuario(_,Red,_).

% c) exclusivo/1 se cumple cuando un influencer está en una única red.

exclusivo(Influencer):-
    redesEnLasQueEsta(Influencer,ListaDeRedes),
    length(ListaDeRedes,CantidadDeRedes),
    CantidadDeRedes = 1.

/*Otra opcion:
exclusivo(Influencer):-
    red(Influencer, Red, _), 
    not((red(Influencer, Red2, _), Red \= Red2)).*/


redesEnLasQueEsta(Influencer,ListaDeRedes):-
    influencer(Influencer),
    findall( Redes, usuario(Influencer,Redes,_), ListaDeRedes).

% 3) 
seRelacionaConJuegos(leagueOfLegends).
seRelacionaConJuegos(minecraft).
seRelacionaConJuegos(aoe).

publicacion(ana,tiktok,video(1,[evelyn,beto])).
publicacion(ana,tiktok,video(1,[ana])).
publicacion(ana,instagram,foto([ana])).

publicacion(beto,instagram,foto([])).

publicacion(cami,twich,stream(leagueOfLegends)).
publicacion(cami,youtube,video(5,[cami])).

publicacion(evelyn,instagram,foto([cami])).

% 4) adictiva/1 se cumple para una red cuando sólo tiene contenidos adictivos

esAdictivaLaRed(Red):-
    existe(Red),
    forall( publicacion(_,Red,Contenidos),
    esAdictivoElContenido(Contenidos) ).

esAdictivoElContenido(video(Tiempo,_)):-
    Tiempo < 3.
esAdictivoElContenido(stream(Tematica)):-
    seRelacionaConJuegos(Tematica).
esAdictivoElContenido(foto(ListaDeParticipantes)):-
    length(ListaDeParticipantes,CantidadDeParticipantes),
    CantidadDeParticipantes < 4.

% 5) colaboran/2 se cumple cuando un usuario aparece en las redes de otro (en alguno de sus contenidos). 
% usuario(cami,tiktok, 2000).

%simetria
colaboran(Usuario, OtroUsuario):-
    participanEnRedes(Usuario, OtroUsuario).
colaboran(Usuario, OtroUsuario):-
    participanEnRedes(OtroUsuario, Usuario).

participanEnRedes(Usuario, OtroUsuario):-
    publicacion(Usuario,_,Contenido),
    publicacion(OtroUsuario,_,_),
    Usuario \= OtroUsuario,
    aparecePersonaEnContenido(OtroUsuario,Contenido).

aparecePersonaEnContenido(OtroUsuario,foto(Participantes)):-
    member(OtroUsuario, Participantes).
aparecePersonaEnContenido(OtroUsuario,video(_,Participantes)):-
    member(OtroUsuario, Participantes).
aparecePersonaEnContenido(OtroUsuario,stream(Tematica)):-
    publicacion(OtroUsuario,_,stream(Tematica)).
    
% caminoALaFama/1 se cumple para un usuario no influencer cuando un influencer publicó contenido en el que aparece el usuario, 
% o bien el influencer publicó contenido donde aparece otro usuario que a su vez publicó contenido donde aparece el usuario. 

caminoALaFama(Usuario):-
    participanEnRedes(Influencer, Usuario), 
    Influencer \= Usuario, 
    not(influencer(Usuario)), 
    tieneFama(Influencer). 

tieneFama(Usuario):- 
    influencer(Usuario). 

tieneFama(Usuario):-
    caminoALaFama(Usuario). %Si influencer no es influencer (valga la redundancia), lo toma como nuevo usuario. Intenta formar cadena indirecta. 
/*
caminoALaFama(Usuario) :-
    usuario(Usuario, _, _),
    not(influencer(Usuario)),
    (influencer(Influencer),
    participanEnRedes(Usuario, Influencer));
    (participanEnRedes(Usuario, OtroUsuario),
    caminoALaFama(OtroUsuario)).


caminoALaFama(Usuario):-
    usuario(Usuario,_,_),
    not(influencer(Usuario)),
    influencer(Influencer),
    participanEnRedes(Usuario,Influencer).

caminoALaFama(Usuario):-
    usuario(Usuario,_,_),
    not(influencer(Usuario)),
    usuario(OtroUsuario,_,_),
    participanEnRedes(Usuario,OtroUsuario),
    caminoALaFama(OtroUsuario).  





*/