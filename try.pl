/* DEKLARASI RULE DYNAMIC DISINI */

/*MAP*/
:- dynamic(tile/3). %%tile berisi koordinat point(X,Y) dan isi tilenya

/*PLAYER*/
:- dynamic(player_position/2).
:- dynamic(player_total_health/1). %original health + armor_health
:- dynamic(player_original_health/1).
:- dynamic(player_armor_health/1). %yang di equip , 0 kalo gaada
:- dynamic(player_equipped_armor/1).
:- dynamic(player_equipped_weapon/2). %Nama dan sisa peluru
:- dynamic(player_inventory/2).
/* Keterangan : */
%player_inventory(<weapon_name>,<weapon_ammo>)
%player_inventory(<armor_name>,<armor_remaining_health>)
%player_inventory(<medicine_name>,<medicine_healing_capacity>)
%player_inventory(<ammo>,<weapon_ammo>) sementara anggep peluru itu universal

:- dynamic(enemy_position/2).
:- dynamic(enemy_inventory/2). %Formatnya sama kayak yang player
%Musuh sekali attack langsung modar sementara, dan gapake armor
:- dynamic(player_equipped_weapon/1).
:- dynamic(item_details/3). %Koordinat baris kolom, nama item

/*DETAILS*/ %%nyawa,duit,waktu,dan lain lain
:- dynamic(time/1).


/*DEKLARASI BESAR MAP*/


/*TERRAIN MAP*/



/*WAKTU*/ %%buat set safezone entar
time(0).

/*ITEM YANG ADA PADA GAME */
%Weapon
item(m416,weapon).
item(scar,weapon).
item(akm,weapon).
item(ump9,weapon).
item(shotgun,weapon).
item(sks,weapon).
item(pistol,weapon).
item(sniper,weapon).
item(bazooka,weapon).
item(grenade,weapon).

item(kutang,armor).
item(kevlarlvl1,armor).
item(kevlarlvl2,armor).
item(kevlarlvl3,armor).

item(ganja,medicine).

item(magazine,ammo).

%Fakta kepasitias peluru setiap senjata
ammo(m416,7).
ammo(scar,7).
ammo(akm,7).
ammo(ump9,5).
ammo(shotgun,5).
ammo(sks,8).
ammo(pistol,10).
ammo(sniper,3).
ammo(bazooka,1).
ammo(grenade,1).

damage(m416,30).
damage(scar,35).
damage(akm,30).
damage(ump9,25).
damage(shotgun,40).
damage(sks,25).
damage(pistol,15).
damage(sniper,80).
damage(bazooka,100).
damage(grenade,70).


%%Mencetak full map
print_map(12,0) :- nl,nl,!.
print_map(X,12) :- nl , nl,  NextRow is X+1,!, print_map(NextRow,0).
print_map(X,Y) :- tile(X,Y,Tile), print_tile(X,Y,Tile), NextCol is Y + 1,!, print_map(X, NextCol).

print_tile(_,_,X) :- X == 'X', ! ,  write('  X  ').
print_tile(Row,Col,_) :- player_position(Row,Col), ! , write('  P  ').
print_tile(Row,Col,_) :- enemy_position(Row,Col), ! , write('  E  ').
print_tile(Row,Col,_) :- (  item_details(Row,Col,Item) ->   
                                (   item(Item,weapon) -> write('  W  ');
                                    item(Item,armor) -> write('  A  ');
                                    item(Item,medicine) -> write('  M  ');
                                    item(Item,ammo) -> write('  O  ')
                                );
                            write('  _  ')
                         ). 

load_map(_,_,[]) :- !.
load_map(X,Y,[Head|Tail]) :- assertz(tile(X,Y,Head)), Y1 is Y + 1, load_map(X,Y1,Tail), ! .


initial_map_r0 :-  load_map(0,0,['X','X','X','X','X','X','X','X','X','X','X','X']).
initial_map_r1 :-  load_map(1,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r2 :-  load_map(2,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r3 :-  load_map(3,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r4 :-  load_map(4,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r5 :-  load_map(5,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r6 :-  load_map(6,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r7 :-  load_map(7,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r8 :-  load_map(8,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r9 :-  load_map(9,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r10 :- load_map(10,0,['X','O','O','O','O','O','O','O','O','O','O','X']).
initial_map_r11 :- load_map(11,0,['X','X','X','X','X','X','X','X','X','X','X','X']).


load_map :- initial_map_r0,
            initial_map_r1,
            initial_map_r2,
            initial_map_r3,
            initial_map_r4,
            initial_map_r5,
            initial_map_r6,
            initial_map_r7,
            initial_map_r8,
            initial_map_r9,
            initial_map_r10,
            initial_map_r11.



update_dead_zone :- time(X), mod(X, 5) =:= 0 , Res is div(X, 5) ,!, forall(tile(Row,Col,_), update_limit_dead_zone(Row,Col,Res)),!,nl,nl,write('The storm is coming...'),nl,nl. %karena mulai dari 0
update_dead_zone :- !.



update_limit_dead_zone(Row,Col,Res) :- Row == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Row == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Col == Res, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(Row,Col,Res) :- Temp is 11 - Res,Col == Temp, retract(tile(Row,Col,_)),assertz(tile(Row,Col,'X')).
update_limit_dead_zone(_,_,_) :- !.


move_player(Direction) :-   Direction == 'n' -> !, player_position(Row,Col), Row1 is Row-1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)).
move_player(Direction) :-   Direction == 's' -> !, player_position(Row,Col), Row1 is Row+1, retractall(player_position(_,_)), assertz(player_position(Row1,Col)).
move_player(Direction) :-   Direction == 'e' -> !, player_position(Row,Col), Col1 is Col+1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)).
move_player(Direction) :-   Direction == 'w' -> !, player_position(Row,Col), Col1 is Col-1, retractall(player_position(_,_)), assertz(player_position(Row,Col1)).

/*DAFTAR IMPLEMENTASI COMMAND YANG DIINPUT PEMAIN*/

n :-    shell(clear),update_time,update_dead_zone, move_player(n),!/*,print_map(0,0)*/,look_nsew.
s :-    shell(clear),update_time,update_dead_zone, move_player(s),!/*,print_map(0,0)*/,look_nsew.
e :-    shell(clear),update_time,update_dead_zone, move_player(e),!/*,print_map(0,0)*/,look_nsew.
w :-    shell(clear),update_time,update_dead_zone, move_player(w),!/*,print_map(0,0)*/,look_nsew.

map:-  shell(clear),print_map(0,0),!.

look :- shell(clear),
        player_position(Row,Col),
        A is Row-1,
        B is Row+1,
        C is Col-1,
        D is Col+1,
        nl,
        tile(A,C,Tile1),print_tile(A,C,Tile1),
        tile(A,Col,Tile2),print_tile(A,Col,Tile2),
        tile(A,D,Tile3),print_tile(A,D,Tile3),nl,nl,
        tile(Row,C,Tile4),print_tile(Row,C,Tile4),
        tile(Row,Col,Tile5),print_tile(Row, Col, Tile5),
        tile(Row,D,Tile6),print_tile(Row, D, Tile6),nl,nl,
        tile(B,C,Tile7),print_tile(B, C, Tile7),
        tile(B,Col,Tile8),print_tile(B, Col, Tile8),
        tile(B,D,Tile9),print_tile(B, D, Tile9),nl,nl,
        /*BAGIAN PESAN*/
        write('You are in Pochinki..'),nl,!,
        look_item_around(A,C),
        look_item_around(A,Col),
        look_item_around(A,D),
        look_item_around(Row,C),
        look_item_around(Row,Col),
        look_item_around(Row,D),
        look_item_around(B,C),
        look_item_around(B,Col),
        look_item_around(B,D).
        
start :-    shell(clear),
            write('    _/_/_/    _/    _/  _/_/_/      _/_/_/'),
            nl,
            write('   _/    _/  _/    _/  _/    _/  _/       '),
            nl,
            write('  _/_/_/    _/    _/  _/_/_/    _/  _/_/  '),
            nl,
            write(' _/        _/    _/  _/    _/  _/    _/   '),
            nl,
            write('_/          _/_/    _/_/_/      _/_/_/    '),
            nl,
            nl,
            write('Welcome to the battlefield!'),
            nl,
            write('You have been chosen as one of the lucky contestants. Be the last man standing and you will be remembered as one of the victors'),
            nl,
            nl,
            help,
            load_map,
            init_player,
            init_item,
            init_enemy,
            look_enemy.
    
help :-     %shell(clear),
            write('Available commands:'),
            nl,
            write('  start. -- start the game!'),
            nl,
            write('  help. -- show available commands'),
            nl,
            write('  quit. -- quit the game'),
            nl,
            write('  look. -- look around you'),
            nl,
            write('  n. s. e. w. -- move'),
            nl,
            write('  map. -- look at the map and detect enemies'),
            nl,
            write('  take(Object). -- pick up an object'),
            nl,
            write('  drop(Object), -- drop an object'),
            nl,
            write('  use(Object), -- use an object'),
            nl,
            write('  attack. -- attack enemy that crosses your path'),
            nl,
            write('  status. -- show your status'),
            nl,
            write('  save(Filename). -- save your game'),
            nl,
            write('  load(Filename). -- load previously saved game'),
            nl,
            nl,
            write('Legends:'),
            nl,
            write('W = weapon\tP = player'),
            nl,
            write('A = armor\tE = enemy'),
            nl,
            write('M = medicine\t- = accessible'),
            nl,
            write('O = ammo\tX = inaccessible'),
            nl,
            nl.

status :- shell(clear),
          show_health,nl,
          show_armor,nl,
          show_weapon,nl,
          show_ammo,
          show_inventory,nl,nl.

quit.

/*FUNGSI-FUNGSI DALAM GAME*/
update_time :- time(X), X1 is X+1, retractall(time(_)), assertz(time(X1)).


look_nsew :- player_position(Row,Col),
             RowUp is Row - 1, RowDown is Row + 1, ColLeft is Col - 1, ColRight is Col + 1,
             write('On your north, '),print_nsew(RowUp,Col),
             write('On your south, '),print_nsew(RowDown,Col),
             write('On your east, '),print_nsew(Row,ColRight),
             write('On your west,'),print_nsew(Row,ColLeft),nl,nl,
             look_enemy.

look_enemy :- forall(enemy_position(Row,Col),(player_position(Row,Col)->write('Enemy spotted! Get ready for combat or run !'),nl,!;!)).

print_nsew(Row,Col) :- enemy_position(Row,Col), !, write(' you can hear enemy nearby, prepare yourself.'),nl.
print_nsew(Row,Col) :- tile(Row,Col,Tile), Tile == 'X', !,  write(' is a dead zone.'),nl.
print_nsew(_,_) :- !, write(' is an open field.'),nl.


look_item_around(Row, Col) :- forall(item_details(Row,Col,Item), (item(Item, medicine), !, write('You see an '), write(Item), (player_position(Row,Col)->write(' lying on the grass'),nl;nl))),!.
look_item_around(Row, Col) :- forall(item_details(Row, Col, Item), (item(Item, armor), !, write('You see an '),write(Item), (player_position(Row,Col)->write(' lying on the grass'),nl;nl))),!.
look_item_around(Row, Col) :- forall(item_details(Row, Col, Item), (item(Item, weapon), !, write('You see an empty '),write(Item),(player_position(Row,Col)->write(' lying on the grass'),nl;nl))),!.
look_item_around(Row, Col) :- forall(item_details(Row, Col, Item), (item(Item, ammo), !, write('You see an '),write(Item), (player_position(Row,Col)->write(' lying on the grass'),nl;nl))),!.
look_item_around(_,_) :- !.

show_health     :-  write('Health : '), player_original_health(X),!, write(X).
show_armor      :-  write('Armor : '), player_armor_health(X), !, write(X).
show_weapon     :-  write('Weapon : '), player_equipped_weapon(X,_), !, write(X).
show_weapon     :-  write('none'),!.
show_ammo       :-  player_equipped_weapon(_,X), !,write('Ammo : '),  write(X),nl.
show_ammo       :-  !.
show_inventory  :-  write('Inventory : '),nl,player_inventory(_,_),!,(forall(player_inventory(X,Y), (write('  '),write(X),(X == magazine->write('('),write(Y),write(')');nl)))).
show_inventory  :-  write('Your inventory is empty !'),nl,!.

/*INISIALISASI*/
init_player :-  assertz(player_position(5,5)),
                assertz(player_total_health(100)),
                assertz(player_original_health(100)),
                assertz(player_armor_health(0)),
                assertz(player_equipped_weapon(sks,25)),
                assertz(player_inventory(ak47,30)),
                assertz(player_inventory(magazine,30)).
                


init_item   :-  assertz(item_details(1,1,grenade)),
                assertz(item_details(3,8,ganja)),
                assertz(item_details(4,9,magazine)),
                assertz(item_details(3,6,sks)),
                assertz(item_details(3,6,m416)).

init_enemy  :-  assertz(enemy_position(6,5)).



/*
start :-    load_map,
            init_player,
            init_item,
            init_enemy,
            map,
            look_enemy.
*/
