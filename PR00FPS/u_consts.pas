unit u_consts;

interface

const
  PRODUCTNAME = 'PR00FPS';                     // A progi neve
  PRODUCTVERSION = '1.0';                      // verzi�ja
  APP_TITLE = PRODUCTNAME+' '+PRODUCTVERSION;  // Alkalmaz�s c�me
  APP_TESTER_WARNING = FALSE;                  // A progi indul�sakor figyelmeztessen-e a tesztverzi�
                                                  // hi�nyoss�gair�l �s esetleges k�vetkezm�nyekr�l
  APP_HINTHIDEPAUSE = 10000;                   // Mennyi ms-ig mutassa a hinteket
  APP_HINTPAUSE     = 200;                     // H�ny ms m�lva mutassa az �j hintet
  APP_HINTCOLOR     = $F0CAA6;                 // Hint ablak h�tt�rsz�nes
  APP_MUTEXNAME     = 'PR00FPS_MUTEX';         // a progi �ltal kre�lt mutex

  { ************************************************************************************************************* }

  WM_SYSCOMMAND       = 274;                   // Window Message konstansok (WndProc()-on bel�l �zenetkezel�shez)
  WM_ACTIVATE         = 6;
  WM_CLOSE            = 16;
  WM_KEYDOWN          = 256;
  WM_KEYUP            = 257;
  WM_QUIT             = 18;
  WM_WINDOWPOSCHANGED = 71;
  WM_MOUSEMOVE        = 512;
  WM_MOUSEWHEEL       = 522;
  WM_LBUTTONDOWN      = 513;
  WM_LBUTTONUP        = 514;
  WM_MBUTTONDOWN      = 519;
  WM_MBUTTONUP        = 520;
  WM_RBUTTONDOWN      = 516;
  WM_RBUTTONUP        = 517;
  WM_PAINT            = 15;

  { ************************************************************************************************************* }

  GAMEWINDOW_CLASSNAME = 'gamewindow';        // F� j�t�kablak oszt�ly�nak neve

  { ************************************************************************************************************* }
  
  ERRORDLG_BASE_TITLE   = 'Hiba';                                               // Hiba eset�n megjelen�tett dial�gus ablak c�me
  ERROR_TMCSINITGRAPHIX = 'Nem siker�lt inicializ�lni a grafikus rendszert.';   // tmcsInitGraphix() nem volt ok
  ERROR_CREATEWINDOWEX  = 'Nem siker�lt l�trehozni az ablakot.';                // f� j�t�kablak createWindowEx()-je nem volt ok
  ERROR_REGISTERCLASS   = 'Nem siker�lt regisztr�lni az oszt�lyt.';             // f� j�t�kablak oszt�ly�nak regje nem volt ok
  ERROR_FMOD_INIT       = 'Nem siker�lt inicializ�lni a hangkezel� rendszert!'+#10+
                          'B�vebb inform�ci�t a dokument�ci�ban tal�l!';        // FMOD nem lett inicializ�lva
  ERROR_NOSP            = 'A p�lya nem tartalmaz kezd�pontot!';                 // no spawnpoint
  ERROR_NOCFG           = 'Nem siker�lt bet�lteni a p�ly�hoz tartoz� be�ll�t�s f�jlt!'; // nincs be�l�t�s f�jl
  ERROR_LOADMAPFAILED   = 'Nem siker�lt bet�lteni a kiv�lasztott p�ly�t!';      // mag��rt besz�l

  { ************************************************************************************************************* }

  DEBUG_COLLISION = FALSE;                                        // collision-z�n�k megjelen�t�se
  DEBUG_BULLETS = FALSE;                                          // l�ved�kek megjelen�t�se
  DEBUG_BOTSMATRIX = FALSE;                                       // botok ir�ny m�trix�nak megjelen�t�se
  DEBUG_WALKTHROUGH = FALSE;                                      // se HUD, se c�lkereszt, se fegyver, se FPS-kijelz�s

  { ************************************************************************************************************* }

  GAME_FPS_INTERVAL = 200;                                       // az fps-statisztik�k friss�t�si intervalluma ms-ben

  GAME_MAXFPS = -1;                                             // max. fps (-1, ha a lehet� legnagyobb fps-t akarjuk el�rni)
  GAME_WORLD_GRAVITY = 20;                                     // gravit�ci�, milyen gyorsan esnek a playerek a talajra
  GAME_WORLD_GRAVITY_MAX = 2000;                                  // max. ennyivel h�zhatja le a dolgokat a gravit�ci�

  GAME_FOV = 60;                                                 // kamera l�t�sz�ge
  GAME_CAMERA_ZOOM_SPEED = 90;                                   // milyen gyorsan lehessen zoomolni a kamer�val
  GAME_CAMERA_ZOOM_MAX = 30;                                     // zoomol�s m�rt�ke (min�l kisebb, ann�l nagyobb a zoom)
                                                                    // tulk�ppen azt mondja, mennyivel lehet max. kisebb a
                                                                    // kamera l�t�sz�ge
  GAME_CAMERA_MIN = 0.1;                                         // kamera k�zeli v�g�s�kja
  GAME_CAMERA_MAX = 800.0;                                       // kamera t�voli v�g�s�kja
  GAME_GAMMA_MAX_R = 255;                                        // max. v�r�s �rt�k gamma-eltol�sn�l
  GAME_GAMMA_MAX_G = 255;                                        // max. z�ld �rt�k gamma-eltol�sn�l
  GAME_GAMMA_MAX_B = 255;                                        // max. k�k �rt�k gamma-eltol�sn�l
  GAME_INACTIVE_SLEEP = 30;                                      // h�ny ms-et v�rjon ciklusonk�nt a progi, ha inakt�v az ablak
  GAME_ASPECTRATIO = 4/3;                                        // renderelt k�p sz�less�g�nek �s magass�g�nak ar�nya
  GAME_LIGHTAMBIENT_R = 0.6;                                     // ambiens f�nyforr�s v�r�s sz�n�sszetev�j�nek er�ss�ge
  GAME_LIGHTAMBIENT_G = 0.6;                                     // ambiens f�nyforr�s z�ld sz�n�sszetev�j�nek er�ss�ge
  GAME_LIGHTAMBIENT_B = 0.6;                                     // ambiens f�nyforr�s k�k sz�n�sszetev�j�nek er�ss�ge
  GAME_SKYBOX_UV_BIAS = 0.001;                                   // skybox UV-koordjait mennyivel tolja el
  GAME_BASE_MBLURALPHA_MULTIPLIER = 1.75;                        // alap motion blur szorz�, ha �lland� motion blur van bekapcsolva
  GAME_BASE_MBLUR_FADESPEED = 30;                                // milyen gyorsan �lljon vissza s�r�l�s ut�n a motion blur
                                                                    // eredeti �rt�ke

  GAME_PATH_MAPS   = 'data\maps\';                                // mapok el�r�si �tvonala
  GAME_PATH_ITEMS  = 'data\items\';                               // itemek el�r�si �tvonala
  GAME_PATH_MENU   = 'data\menu\';                                // men� el�r�si �tvonala
  GAME_PATH_HUD    = 'data\hud\';                                 // HUD el�r�si �tvonala
  GAME_PATH_WPNS   = 'data\wpns\';                                // fegyver modellek el�r�si �tvonala
  GAME_PATH_BOTS   = 'data\bots\';                                // bot modellek el�r�si �tvonala
  GAME_PATH_ETC    = 'data\etc\';                                 // egyebek el�r�si �tvonala
  GAME_PATH_SOUNDS = 'data\sounds\';                              // hangok el�r�si �tvonala

  GAME_LOADING_TEXTS: array[0..15] of string = ('Beviteli rendszer ...',
                                                '�tk�z�si rendszer ...',
                                                'P�lya, itemek ...',
                                                '�tk�z�si z�n�k, �gbolt, stb. ...',
                                                'C�lkereszt ...',
                                                'Frag t�bla ...',
                                                'HUD ...',
                                                'Men� ...',
                                                '�tk�z�si z�n�k ...',
                                                'Fegyverek ...',
                                                'K�t kis text�ra ...',
                                                'Botok ...',
                                                'Csiga hozz�ad�sa ...',
                                                'Robot hozz�ad�sa ...',
                                                'Hangok ...',
                                                'Motion blur ...'
                                               );
                                              // T�lt�k�perny�n megjelen� sz�vegek

  GAME_FRAGTABLE_CAPTION = 'Frag t�bla';      // Frag t�bla c�me
  GAME_FRAGTABLE_HEADER1 = 'N�v';             // Frag t�bla 1. oszlop�nak c�me
  GAME_FRAGTABLE_HEADER2 = 'Fragek';          // Frag t�bla 2. oszlop�nak c�me
  GAME_FRAGTABLE_HEADER3 = 'Hal�lok';         // Frag t�bla 3. oszlop�nak c�me

  GAME_INGAME_MENU_MOUSEHIDETIME = 1000;                         // in-game men�ben az eg�rkurzor utols� elmozdul�s�t�l sz�m�tva
                                                                    // h�ny millisec m�lva rejts�k el az eg�rkurzort
  GAME_INGAME_MENU_BTNCOUNT = 6;                                 // in-game men�ben gombok sz�ma
  GAME_INGAME_MENU_BTNFILE: array[1..GAME_INGAME_MENU_BTNCOUNT] of string   // in-game men� gombjainak "mouseUp" �llapotai
                              = ('menubtn_cont_up.bmp',
                                 'menubtn_bots_up.bmp',
                                 'menubtn_settings_up.bmp',
                                 'menubtn_restart_up.bmp',
                                 'menubtn_newgame_up.bmp',
                                 'menubtn_exit_up.bmp');
  GAME_INGAME_MENU_BTNFILE_OVER: array[1..GAME_INGAME_MENU_BTNCOUNT] of string  // in-game men� gombjainak "mouseOver" �llapotai
                                   = ('menubtn_cont_over.bmp',
                                      'menubtn_bots_over.bmp',
                                      'menubtn_settings_over.bmp',
                                      'menubtn_restart_over.bmp',
                                      'menubtn_newgame_over.bmp',
                                      'menubtn_exit_over.bmp');
  GAME_INGAME_MENU_BTN_EFFECTIVE_WIDTH = 200;                    // in-game men� gombjainak val�s sz�less�ge
                                                                    // (kisebb, mint a k�p sz�less�ge)
  GAME_INGAME_MENU_BTN_EFFECTIVE_HEIGHT = 42;                    // in-game men� gombjainak val�s magass�ga
                                                                    // (kisebb, mint a k�p magass�ga)
  GAME_INGAME_MENU_BTN_Y_BIAS = 10;                              // in-game men� gombjainak y-koordj�hoz +ennyit kell hozz�adni

  GAME_XHAIR_WIDTH = 0.05;                                       // c�kereszt sz�less�ge
  GAME_XHAIR_HEIGHT = 0.0625;                                      // c�lkereszt magass�ga
  GAME_XHAIR_MAX_SCALING = 150;                                  // c�lkereszt max. nagy�that�s�ga (sz�zal�k)
  GAME_XHAIR_UPSCALE_SPEED = 400;                                // c�lkereszt milyen gyorsan n�j�n
  GAME_XHAIR_DOWNSCALE_SPEED = 100;                              // c�lkereszt milyen gyorsan zsugorodjon

  GAME_MAX_HEALTH = 100;                                       // max. �leter�
  GAME_MAX_SHIELD = 100;                                       // max.pajzs

  GAME_MAX_ITEMS_TEXT = 3;
  GAME_ITEMS_TEXTS: array[0..7] of string = ('Teleport',
                                             '�leter�',
                                             'Pajzs',
                                             '4x-es sebz�s',
                                             'T�r pisztolyhoz',
                                             'T�r g�ppityuhoz',
                                             '5 db-os rak�ta csomag',
                                             ''); // felvett item sz�vegei
  GAME_EVENTS_DEATH_DIVIDERSTRING = ' >>> ';                     // hal�lok ki�r�s�n�l n�v elv�laszt�
  GAME_EVENTS_DEATH_SUICIDESTRING = ' � ';                       // �ngyilkoss�gn�l ez jelenik meg a n�v el�tt
  GAME_ITEMS_SCALE = 10;                                         // item objektumok sk�l�z�si ar�nya
  GAME_ITEMS_HEIGHTPLUS_SPEED = 500;                             // itemek fel-le mozg�s�nak sebess�ge
  GAME_ITEMS_YROTPLUS_SPEED = 50;                                // itemek forg�si sebess�ge
  GAME_ITEM_TELEPORT_RESPAWNTIME = 10000;                        // teleport �jratermel�si ideje ms-ben
  GAME_ITEM_HEALTH_RESPAWNTIME = 5000;                           // �leter� �jratermel�si ideje ms-ben
  GAME_ITEM_HEALTH = 25;                                         // �leter�-item ennyi HP-t ad
  GAME_ITEM_SHIELD_RESPAWNTIME = 5000;                           // pajzs �jratermel�si ideje ms-ben
  GAME_ITEM_SHIELD = 50;                                         // �leter�-item ennyi SP-t ad
  GAME_ITEM_WPN_PISTOL_MAX = 99;                                 // max. ennyi t�lt�ny lehet a pisztolyhoz
  GAME_ITEM_WPN_MCHGUN_MAX = 99;                                 // max. ennyi t�lt�ny lehet a g�pfegyverhez
  GAME_ITEM_WPN_ROCKETLAUNCHER_MAX = 99;                         // max. ennyi rak�ta lehet a rak�tavet�h�z
  GAME_ITEM_WPN_ROCKETLAUNCHER_MAXPACK = 5;                      // max. ennyi rak�ta lehet "bet�razva"
  GAME_ITEM_WPN_PISTOL_AMMO_DEF = 8;                             // pisztolyhoz t�lt�ny item ennyi l�szert ad
  GAME_ITEM_WPN_PISTOL_RESPAWNTIME = 5000;                       // pisztoly t�lt�ny item �jratermel�si ideje
  GAME_ITEM_WPN_MCHGUN_RESPAWNTIME = 5000;                       // g�pfegyver t�lt�ny item �jratermel�si ideje
  GAME_ITEM_WPN_ROCKETLAUNCHER_RESPAWNTIME = 5000;               // rak�ta item �jratermel�si ideje
  GAME_ITEM_WPN_MCHGUN_AMMO_DEF = 30;                            // g�pfegyverhez t�lt�ny item ennyi l�szert ad
  GAME_ITEM_WPN_ROCKETLAUNCHER_AMMO_DEF = 5;                     // rak�tavet�h�z item ennyi rak�t�t ad
  GAME_ITEM_QUADDAMAGE_TIME = 20000;                             // ennyi ideig lehet egy playern�l a 4x-es sebz�s
  GAME_ITEM_QUADDAMAGE_SPEED = 1000;                             // 4x-es sebz�s mozg�s�nak sebess�ge
  GAME_ITEM_QUADDAMAGE_RESPAWNTIME = 30000;                      // 4x-es sebz�s �jratermel�si ideje

  GAME_HUD_HEALTH_MIN = 25;                                      // ennyi �leter� alatt pirosan villog az �leter�t jelz� sz�m
  GAME_HUD_BLINK_INTERVAL = 200;                                 // villog�sn�l h�ny ms-enk�nt v�ltson sz�nt
  GAME_HUD_ITEMS_TEXT_WAITBEFOREFADE = 1000;                     // h�ny ms m�lva kezdjen el halv�nyodni az item text
  GAME_HUD_ITEMS_TEXT_FADESPEED = 100;                           // milyen gyorsan halv�nyodjon el az item text
  GAME_HUD_MAJORTEXT_WAITBEFOREFADE = 3000;                      // h�ny ms-ig l�tsz�djon a teleport�l�s
  GAME_HUD_MAJORTEXT_FADESPEED = 500;                            // milyen gyorsan halv�nyodjon el a teleport�l�s sz�veg

  GAME_INJURYCAUSEDBYFALLING = 30;                               // mennyire legyen nagy az es�s okozta sebz�s

  GAME_TIMETOREVIVE = 1000;                                      // hal�l ut�n ennyi ms-et kell v�rni az �jra�led�shez

  GAME_WPN_MAX = 3;                                              // h�ny k�l�nb�z� fegyver van
  GAME_WPN_SCALING = 5;                                          // h�ny %-ra vannak lekicsiny�tve a fegyverek

  GAME_WPN_PISTOL_BULLET_DMG = 8;                               // pisztoly egy l�ved�ke mennyit sebez
  GAME_WPN_MCHGUN_BULLET_DMG = 5;                               // g�pfegyver egy l�ved�ke mennyit sebez
  GAME_WPN_ROCKETLAUNCHER_BULLET_DMG = 20;                      // rak�ta sebz�se (ha nem impulse, hanem direkt tal�lat van)
  GAME_BULLET_MOVEMENT_SUBDIVISION = 2;                          // h�nyszor legyen pontosabb a l�ved�kek �tk�z�s�nek sebess�ge
  GAME_PISTOL_BULLET_SPEED = 40;                                 // pisztoly l�ved�k�nek sebess�ge
  GAME_PISTOL_BULLET_SIZEX = 0.01;                               // pisztoly l�ved�k�nek sz�less�ge
  GAME_PISTOL_BULLET_SIZEY = 0.01;                               // pisztoly l�ved�k�nek magass�ga
  GAME_PISTOL_BULLET_SIZEZ = 0.01;                               // pisztoly l�ved�k�nek hossza
  GAME_MCHGUN_BULLET_SPEED = 40;                                 // g�pfegyver l�ved�k�nek sebess�ge
  GAME_MCHGUN_BULLET_SIZEX = 0.01;                               // g�pfegyver l�ved�k�nek sz�less�ge
  GAME_MCHGUN_BULLET_SIZEY = 0.01;                               // g�pfegyver l�ved�k�nek magass�ga
  GAME_MCHGUN_BULLET_SIZEZ = 0.01;                               // g�pfegyver l�ved�k�nek hossza
  GAME_ROCKET_SPEED = 13;                                        // rak�ta sebess�ge
  GAME_ROCKET_SCALING = 10;                                      // rak�ta objektum m�ret�nek sk�l�z�si m�rt�ke
  GAME_ROCKET_XPLOSION_STARTSCALE = 10;                          // rak�ta okozta robban�s g�mbj�nek kezdeti m�rete
  GAME_ROCKET_XPLOSION_STOPSCALE = 200;                          // rak�ta okozta robban�s g�mbj�nek v�gs� m�rt�ke
  GAME_ROCKET_XPLOSION_SCALESPEED = 8;                           // milyen gyorsan n�j�n a robban�s g�mbje
  GAME_ROCKET_XPLOSION_IMPULSE_DIST = GAME_ROCKET_XPLOSION_STOPSCALE / 10; // a rak�ta becsap�d�si hely�t�l mennyire t�volra
                                                                             // hasson a robban�s
  GAME_ROCKET_XPLOSION_IMPULSE = 1;                              // a rak�ta robann�sa okozta l�k�s ereje
  GAME_ROCKET_XPLOSION_IMPULSE_DMG = 0.1;                        // rak�ta okozta s�r�l�s, ha l�ki a playert
  GAME_ROCKET_SMOKE_SCALESPEED = 200;                            // milyen gyorsan n�j�n a f�st
  GAME_ROCKET_SMOKE_STOPSCALE = 400;                             // h�ny %-ra n�j�n a f�st, miel�tt elt�nik
  GAME_ROCKET_SMOKE_STARTSIZE = 2.0;                             // l�trehoz�sn�l mekkora legyen a f�st (plane m�rete)
  GAME_ROCKET_SMOKE_SPEED = 0.05;                                // milyen gyorsan mozogjon a f�st a rak�ta ir�ny�ba

  GAME_WPN_PISTOL_ACCURACY = 5;                                  // pisztoly l�v�s pontoss�ga
  GAME_WPN_MCHGUN_ACCURACY = 5;                                  // g�pfegyver l�v�s pontoss�ga
  GAME_WPN_ROCKET_ACCURACY = 5;                                  // rak�tavet� l�v�s pontoss�ga
  
  GAME_WPN_MCHGUN_LCD_ALPHA_MIN = 100;                           // g�pfegyver kijelz�j�nek min. �tl�tsz�s�ga
  GAME_WPN_MCHGUN_LCD_ALPHA_MAX = 150;                           // g�pfegyver kijelz�j�nek max. �tl�tsz�s�ga
  GAME_WPN_MCHGUN_LCD_ALPHA_CHANGESPEED = 8;                     // milyen gyorsan pulz�ljon a g�pfegyver kijelz�j�n a sz�m
  GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MIN = 40;                     // g�pfegyver kijelz� figyelmeztet� sz�veg kikapcsolva
  GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MAX = 255;                    // g�pfegyver kijelz� figyelmeztet� sz�veg bekapcsolva
  GAME_WPN_MCHGUN_WARNINGNUM = 10;                               // g�pfegyver kijelz� figyelmeztet� sz�veg h�ny t�lt�nyn�l jelenik meg

  GAME_MARKS_DISTFROMWALLS = 0.05;                               // milyen t�vol rakja a falt�l a markokat, hogy ne legyen z-bug
  GAME_MARKS_SIZEX = 0.2;                                        // mark sz�less�ge
  GAME_MARKS_SIZEY = 0.2;                                        // mark magass�ga
  GAME_MARKS_REPOSITIONING_SPEED = 0.05;                         // milyen gyorsan poz�cion�lja v�gleges helyre a markokat
  GAME_MARKS_FREEZETIME = 30000;                                 // mennyi id� m�lva kezdjenek el halv�nyodni a markok (ms)

  BOTS_SNAIL_SCALE = 13;                                    // csiga mennyire zsugorodjon alapb�l bet�lt�s ut�n
  BOTS_ROBOT_SCALE = 25;                                    // robot mennyire zsugorodjon alapb�l bet�lt�s ut�n
  BOTS_DEATH_YROTSPEED = 100;                                 // bot hal�lakor forgat�si sebess�g n�vel�se
  BOTS_DEATH_YROTSPEED_MAX = 0.2;                           // forgat�si sebess�g max. �rt�ke
  BOTS_DEATH_SCALESPEED = 10;                               // milyen gyorsan zsugor�tsa a botot
  BOTS_DEATH_SMOKE_SIZE = 4;                              // mekkora legyen a gener�lt f�st�k m�rete
  BOTS_DMG_BLOOD_SIZE = 1;                                // v�r m�rete
  BOTS_PATH_MAT_E_NUM_X = 5;                              // a p�lya m�trixb�l ennyi oszlopot l�t maga k�r�l a bot
  BOTS_PATH_MAT_E_NUM_Z = BOTS_PATH_MAT_E_NUM_X;          // a p�lya m�trixb�l ennyi sort l�t maga k�r�l a bot
  BOTS_DIST_STARTATTACK = 70;                             // milyen t�volr�l kezd el t�madni a bot
  BOTS_DIST_ATTACKMAXYDIST = 5;                           // max. ekkora magass�g k�l�nbs�gn�l t�mad a bot
  BOTS_TIME_BETWEEN_SHOTS_SNAIL = 500;                    // csiga l�v�sei k�z�tt eltelt id� ms-ben
  BOTS_TIME_BETWEEN_SHOTS_ROBOT = 100;                    // robot l�v�sei k�z�tt eltelt id� ms-ben
  BOTS_MOVE_SPEED_SNAIL = 20;                             // csiga sebess�ge
  BOTS_MOVE_SPEED_ROBOT = 15;                             // robot sebess�ge
  BOTS_SNAIL_ROCKET_START_Y = 2;                          // csiga poz�ci�j�hoz k�pest mennyivel magasabban j�jj�n l�tre a kil�tt l�ved�k
  BOTS_ROBOT_BULLET_START_Y = 1;                          // robot poz�ci�j�hoz k�pest mennyivel magasabban j�jj�n l�tre a kil�tt l�ved�k
  BOTS_FLOATING_SPEED = 20.0;                             // robot lebeg�si sebess�ge

  { ************************************************************************************************************* }

  PLAYER_DEFAULTNAME                = 'N�vtelen J�t�kos';        // player alap�rt. neve
  PLAYER_SIZEX                      = 4.5;                       // player m�rete az x-tengelyen
  PLAYER_SIZEY                      = 10.0;                      // player m�rete az y-tengelyen
  PLAYER_SIZEZ                      = 4.5;                       // player m�rete az z-tengelyen
  PLAYER_MOVE_RUN                   = 90.0;                      // player fut�si sebess�ge
  PLAYER_MOVE_WALK                  = 30.0;                      // player s�t�l�si sebess�ge
  PLAYER_ROTATE                     = 1.0;                       // player fordul�si sebess�ge (ir�nybillenty�k)

  PLAYER_JUMP_START                 = 4;                         // milyen er�vel hajt felfele minket az ugr�s kezdetekor
  PLAYER_MAXXANGLE                  = 85.0;                      // player max. forg�ssz�ge x-tengelyen (ne fordulhasson k�rbe)
  PLAYER_CAMSHAKE_YPOS              = 15;                        // kamera f�gg�leges r�z�si sebess�ge
  PLAYER_CAMSHAKE_YANG              = 7;                         // kamera y-tengelyes ir�nysz�ggel val� r�z�si sebess�ge
  PLAYER_CAMSHAKE_YPOSDIV           = 7;                         // kamera f�gg�leges r�z�si m�rt�ke
                                                                    // (min�l kisebb, ann�l er�teljesebb a l�p�s)
  PLAYER_CAMSHAKE_YANGDIV           = 3;                         // kamera y-tengelyes ir�nysz�ggel val� r�z�si m�rt�ke
                                                                    // (min�l kisebb, ann�l er�teljesebb a r�z�s)
  PLAYER_MAX_PASSABLE_HEIGHT_BOXES  = 1.0;                       // max. mennyivel lehet magasabban a player l�b�t�l egy
                                                                    // box collision-�s t�rgy, h fel lehessen r� l�pni
  PLAYER_MAX_PASSABLE_HEIGHT_SLOPES = 0.5;                       // max. mennyivel lehet magasabban a player l�b�t�l egy
                                                                    // slope collision-�s t�rgy, h fel lehessen r� l�pni
  PLAYER_HEADPOSY                   = 3.0;                       // a talaj+PLAYER_SIZEY/2-h�z viszony�tva milyen magass�gban van
                                                                    // a player feje
  PLAYER_WPN_DEFAULT = 1;                                        // alap�rt. fegyver, ami a playern�l van
  PLAYER_WPN_SHAKE_RATE = 30/29;                                 // mennyire r�zza a fegyvert l�p�s k�zben f�gg�legesen,
                                                                    // min�l kisebb, ann�l kev�sb� r�zza
  PLAYER_WPN_PISTOL_YPOS_BIAS = -0.1;                            // fel-le n�zel�d�s k�zben hogyan mozduljon el a pisztoly a
                                                                    // kamer�hoz k�pest.
                                                                    // =0 = nincs elmozdul�s
                                                                    // <0 = felfele n�z�skor k�zeledik, lefele n�z�skor t�volodik
                                                                    // >0 = felfele n�z�skor t�volodik, lefele n�z�skor k�zeledik
  PLAYER_WPN_MCHGUN_YPOS_BIAS = -0.1;                            // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_YPOS_BIAS = -0.01;                   // uez rak�tavet�n�l
  PLAYER_WPN_CHANGE_SPEED = 270;                                 // a fegyverv�lt�s sebess�ge. Min�l nagyobb, ann�l gyorsabban
                                                                    // v�ltunk fegyvert
  PLAYER_WPN_CHANGE_ANGLEMAX = 60;                               // fegyver elrak�s�n�l/el�v�tel�n�l h�ny fokkal forgassa el/h�ny fokr�l
                                                                    // forgassa vissza az x-tengelyen a fegyvermodellt

  PLAYER_WPN_PISTOL_SHOTZANGLE = -10;                            // mennyire ugorjon fel l�v�sn�l a pisztoly (fok a Z-tengelyen)
  PLAYER_WPN_MCHGUN_SHOTZANGLE = -1;                             // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLE = -10;                    // uez rak�tavet�n�l
  PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEED = 300;                 // milyen gyorsan ugorjon fel l�v�skor a pisztoly
  PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEED = 100;                 // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEED = 200;         // uez rak�tavet�n�l
  PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEEDAFTER = 60;             // milyen gyorsan h�zza vissza a k�z a pisztolyt l�v�s ut�n
  PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEEDAFTER = 20;             // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEEDAFTER = 20;     // uez rak�tavet�n�l
  PLAYER_WPN_MCHGUN_TIMEBETWEENSHOTS = 100;                      // h�ny ms-nek kell eltelnie k�t l�v�s k�z�tt g�pfegyvern�l
  PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEED = 180;                 // egy l�v�s mennyire ford�tja el a g�pfegyvert
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLECHANGESPEED = 180;         // uez raksin�l
  PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEEDAFTER = 20;             // milyen gyorsan h�zom vissza k�z�pre a g�pfegyvert l�v�s ut�n
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLECHANGESPEEDAFTER = 20;     // uez raksin�l
  PLAYER_WPN_MCHGUN_SHOTYANGLE_MAX = 3;                          // max h�ny fokig fordulhat el a g�pfegyver l�v�sn�l
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLE_MAX = 3;                  // uez raksin�l

  PLAYER_WPN_PISTOL_RELOADZANGLE = 0;                            // �jrat�lt�sn�l mennyire ford�tsa le a fegyvert
  PLAYER_WPN_MCHGUN_RELOADZANGLE = 0;                            // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLE = 20;                   // uez raksin�l
  PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEED = 0;                 // milyen gyorsan ford�tsa le �jrat�lt�sn�l a pisztolyt
  PLAYER_WPN_MCHUGN_RELOADZANGLECHANGESPEED = 0;                 // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEED = 60;        // uez rak�tavet�n�l
  PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEEDAFTER = 0;            // �jrat�lt�s ut�n milyen gyorsan h�zza vissza a pisztolyt
  PLAYER_WPN_MCHGUN_RELOADZANGLECHANGESPEEDAFTER = 0;            // uez g�pfegyvern�l
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEEDAFTER = 60;   // uez rak�tavet�n�l
  PLAYER_WPN_ROCKETLAUNCHER_TIME_BETWEEN_RELOAD_STEPS = 500;     // rak�tavet� �jrat�lt�s�n�l h�ny ms-et v�rjon 1-1 raksi
                                                                    // bet�lt�se k�z�tt
  PLAYER_WPN_ROCKETLAUNCHER_STEPS_TO_SHOW_COUNT = 10;            // h�ny elmozd�t�s ut�n tegy�k l�that�v� a rak�t�t
                                                                    // (hogy ne l�tsz�djon, h a fej�knb�l j�n ki)

implementation

end.
