unit u_consts;

interface

const
  PRODUCTNAME = 'PR00FPS';                     // A progi neve
  PRODUCTVERSION = '1.0';                      // verziója
  APP_TITLE = PRODUCTNAME+' '+PRODUCTVERSION;  // Alkalmazás címe
  APP_TESTER_WARNING = FALSE;                  // A progi indulásakor figyelmeztessen-e a tesztverzió
                                                  // hiányosságairól és esetleges következményekrõl
  APP_HINTHIDEPAUSE = 10000;                   // Mennyi ms-ig mutassa a hinteket
  APP_HINTPAUSE     = 200;                     // Hány ms múlva mutassa az új hintet
  APP_HINTCOLOR     = $F0CAA6;                 // Hint ablak háttérszínes
  APP_MUTEXNAME     = 'PR00FPS_MUTEX';         // a progi által kreált mutex

  { ************************************************************************************************************* }

  WM_SYSCOMMAND       = 274;                   // Window Message konstansok (WndProc()-on belül üzenetkezeléshez)
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

  GAMEWINDOW_CLASSNAME = 'gamewindow';        // Fõ játékablak osztályának neve

  { ************************************************************************************************************* }
  
  ERRORDLG_BASE_TITLE   = 'Hiba';                                               // Hiba esetén megjelenített dialógus ablak címe
  ERROR_TMCSINITGRAPHIX = 'Nem sikerült inicializálni a grafikus rendszert.';   // tmcsInitGraphix() nem volt ok
  ERROR_CREATEWINDOWEX  = 'Nem sikerült létrehozni az ablakot.';                // fõ játékablak createWindowEx()-je nem volt ok
  ERROR_REGISTERCLASS   = 'Nem sikerült regisztrálni az osztályt.';             // fõ játékablak osztályának regje nem volt ok
  ERROR_FMOD_INIT       = 'Nem sikerült inicializálni a hangkezelõ rendszert!'+#10+
                          'Bõvebb információt a dokumentációban talál!';        // FMOD nem lett inicializálva
  ERROR_NOSP            = 'A pálya nem tartalmaz kezdõpontot!';                 // no spawnpoint
  ERROR_NOCFG           = 'Nem sikerült betölteni a pályához tartozó beállítás fájlt!'; // nincs beálítás fájl
  ERROR_LOADMAPFAILED   = 'Nem sikerült betölteni a kiválasztott pályát!';      // magáért beszél

  { ************************************************************************************************************* }

  DEBUG_COLLISION = FALSE;                                        // collision-zónák megjelenítése
  DEBUG_BULLETS = FALSE;                                          // lövedékek megjelenítése
  DEBUG_BOTSMATRIX = FALSE;                                       // botok irány mátrixának megjelenítése
  DEBUG_WALKTHROUGH = FALSE;                                      // se HUD, se célkereszt, se fegyver, se FPS-kijelzés

  { ************************************************************************************************************* }

  GAME_FPS_INTERVAL = 200;                                       // az fps-statisztikák frissítési intervalluma ms-ben

  GAME_MAXFPS = -1;                                             // max. fps (-1, ha a lehetõ legnagyobb fps-t akarjuk elérni)
  GAME_WORLD_GRAVITY = 20;                                     // gravitáció, milyen gyorsan esnek a playerek a talajra
  GAME_WORLD_GRAVITY_MAX = 2000;                                  // max. ennyivel húzhatja le a dolgokat a gravitáció

  GAME_FOV = 60;                                                 // kamera látószöge
  GAME_CAMERA_ZOOM_SPEED = 90;                                   // milyen gyorsan lehessen zoomolni a kamerával
  GAME_CAMERA_ZOOM_MAX = 30;                                     // zoomolás mértéke (minél kisebb, annál nagyobb a zoom)
                                                                    // tulképpen azt mondja, mennyivel lehet max. kisebb a
                                                                    // kamera látószöge
  GAME_CAMERA_MIN = 0.1;                                         // kamera közeli vágósíkja
  GAME_CAMERA_MAX = 800.0;                                       // kamera távoli vágósíkja
  GAME_GAMMA_MAX_R = 255;                                        // max. vörös érték gamma-eltolásnál
  GAME_GAMMA_MAX_G = 255;                                        // max. zöld érték gamma-eltolásnál
  GAME_GAMMA_MAX_B = 255;                                        // max. kék érték gamma-eltolásnál
  GAME_INACTIVE_SLEEP = 30;                                      // hány ms-et várjon ciklusonként a progi, ha inaktív az ablak
  GAME_ASPECTRATIO = 4/3;                                        // renderelt kép szélességének és magasságának aránya
  GAME_LIGHTAMBIENT_R = 0.6;                                     // ambiens fényforrás vörös színösszetevõjének erõssége
  GAME_LIGHTAMBIENT_G = 0.6;                                     // ambiens fényforrás zöld színösszetevõjének erõssége
  GAME_LIGHTAMBIENT_B = 0.6;                                     // ambiens fényforrás kék színösszetevõjének erõssége
  GAME_SKYBOX_UV_BIAS = 0.001;                                   // skybox UV-koordjait mennyivel tolja el
  GAME_BASE_MBLURALPHA_MULTIPLIER = 1.75;                        // alap motion blur szorzó, ha állandó motion blur van bekapcsolva
  GAME_BASE_MBLUR_FADESPEED = 30;                                // milyen gyorsan álljon vissza sérülés után a motion blur
                                                                    // eredeti értéke

  GAME_PATH_MAPS   = 'data\maps\';                                // mapok elérési útvonala
  GAME_PATH_ITEMS  = 'data\items\';                               // itemek elérési útvonala
  GAME_PATH_MENU   = 'data\menu\';                                // menü elérési útvonala
  GAME_PATH_HUD    = 'data\hud\';                                 // HUD elérési útvonala
  GAME_PATH_WPNS   = 'data\wpns\';                                // fegyver modellek elérési útvonala
  GAME_PATH_BOTS   = 'data\bots\';                                // bot modellek elérési útvonala
  GAME_PATH_ETC    = 'data\etc\';                                 // egyebek elérési útvonala
  GAME_PATH_SOUNDS = 'data\sounds\';                              // hangok elérési útvonala

  GAME_LOADING_TEXTS: array[0..15] of string = ('Beviteli rendszer ...',
                                                'Ütközési rendszer ...',
                                                'Pálya, itemek ...',
                                                'Ütközési zónák, égbolt, stb. ...',
                                                'Célkereszt ...',
                                                'Frag tábla ...',
                                                'HUD ...',
                                                'Menü ...',
                                                'Ütközési zónák ...',
                                                'Fegyverek ...',
                                                'Két kis textúra ...',
                                                'Botok ...',
                                                'Csiga hozzáadása ...',
                                                'Robot hozzáadása ...',
                                                'Hangok ...',
                                                'Motion blur ...'
                                               );
                                              // Töltõképernyõn megjelenõ szövegek

  GAME_FRAGTABLE_CAPTION = 'Frag tábla';      // Frag tábla címe
  GAME_FRAGTABLE_HEADER1 = 'Név';             // Frag tábla 1. oszlopának címe
  GAME_FRAGTABLE_HEADER2 = 'Fragek';          // Frag tábla 2. oszlopának címe
  GAME_FRAGTABLE_HEADER3 = 'Halálok';         // Frag tábla 3. oszlopának címe

  GAME_INGAME_MENU_MOUSEHIDETIME = 1000;                         // in-game menüben az egérkurzor utolsó elmozdulásától számítva
                                                                    // hány millisec múlva rejtsük el az egérkurzort
  GAME_INGAME_MENU_BTNCOUNT = 6;                                 // in-game menüben gombok száma
  GAME_INGAME_MENU_BTNFILE: array[1..GAME_INGAME_MENU_BTNCOUNT] of string   // in-game menü gombjainak "mouseUp" állapotai
                              = ('menubtn_cont_up.bmp',
                                 'menubtn_bots_up.bmp',
                                 'menubtn_settings_up.bmp',
                                 'menubtn_restart_up.bmp',
                                 'menubtn_newgame_up.bmp',
                                 'menubtn_exit_up.bmp');
  GAME_INGAME_MENU_BTNFILE_OVER: array[1..GAME_INGAME_MENU_BTNCOUNT] of string  // in-game menü gombjainak "mouseOver" állapotai
                                   = ('menubtn_cont_over.bmp',
                                      'menubtn_bots_over.bmp',
                                      'menubtn_settings_over.bmp',
                                      'menubtn_restart_over.bmp',
                                      'menubtn_newgame_over.bmp',
                                      'menubtn_exit_over.bmp');
  GAME_INGAME_MENU_BTN_EFFECTIVE_WIDTH = 200;                    // in-game menü gombjainak valós szélessége
                                                                    // (kisebb, mint a kép szélessége)
  GAME_INGAME_MENU_BTN_EFFECTIVE_HEIGHT = 42;                    // in-game menü gombjainak valós magassága
                                                                    // (kisebb, mint a kép magassága)
  GAME_INGAME_MENU_BTN_Y_BIAS = 10;                              // in-game menü gombjainak y-koordjához +ennyit kell hozzáadni

  GAME_XHAIR_WIDTH = 0.05;                                       // cékereszt szélessége
  GAME_XHAIR_HEIGHT = 0.0625;                                      // célkereszt magassága
  GAME_XHAIR_MAX_SCALING = 150;                                  // célkereszt max. nagyíthatósága (százalék)
  GAME_XHAIR_UPSCALE_SPEED = 400;                                // célkereszt milyen gyorsan nõjön
  GAME_XHAIR_DOWNSCALE_SPEED = 100;                              // célkereszt milyen gyorsan zsugorodjon

  GAME_MAX_HEALTH = 100;                                       // max. életerõ
  GAME_MAX_SHIELD = 100;                                       // max.pajzs

  GAME_MAX_ITEMS_TEXT = 3;
  GAME_ITEMS_TEXTS: array[0..7] of string = ('Teleport',
                                             'Életerõ',
                                             'Pajzs',
                                             '4x-es sebzés',
                                             'Tár pisztolyhoz',
                                             'Tár géppityuhoz',
                                             '5 db-os rakéta csomag',
                                             ''); // felvett item szövegei
  GAME_EVENTS_DEATH_DIVIDERSTRING = ' >>> ';                     // halálok kiírásánál név elválasztó
  GAME_EVENTS_DEATH_SUICIDESTRING = ' † ';                       // öngyilkosságnál ez jelenik meg a név elõtt
  GAME_ITEMS_SCALE = 10;                                         // item objektumok skálázási aránya
  GAME_ITEMS_HEIGHTPLUS_SPEED = 500;                             // itemek fel-le mozgásának sebessége
  GAME_ITEMS_YROTPLUS_SPEED = 50;                                // itemek forgási sebessége
  GAME_ITEM_TELEPORT_RESPAWNTIME = 10000;                        // teleport újratermelési ideje ms-ben
  GAME_ITEM_HEALTH_RESPAWNTIME = 5000;                           // életerõ újratermelési ideje ms-ben
  GAME_ITEM_HEALTH = 25;                                         // életerõ-item ennyi HP-t ad
  GAME_ITEM_SHIELD_RESPAWNTIME = 5000;                           // pajzs újratermelési ideje ms-ben
  GAME_ITEM_SHIELD = 50;                                         // életerõ-item ennyi SP-t ad
  GAME_ITEM_WPN_PISTOL_MAX = 99;                                 // max. ennyi töltény lehet a pisztolyhoz
  GAME_ITEM_WPN_MCHGUN_MAX = 99;                                 // max. ennyi töltény lehet a gépfegyverhez
  GAME_ITEM_WPN_ROCKETLAUNCHER_MAX = 99;                         // max. ennyi rakéta lehet a rakétavetõhöz
  GAME_ITEM_WPN_ROCKETLAUNCHER_MAXPACK = 5;                      // max. ennyi rakéta lehet "betárazva"
  GAME_ITEM_WPN_PISTOL_AMMO_DEF = 8;                             // pisztolyhoz töltény item ennyi lõszert ad
  GAME_ITEM_WPN_PISTOL_RESPAWNTIME = 5000;                       // pisztoly töltény item újratermelési ideje
  GAME_ITEM_WPN_MCHGUN_RESPAWNTIME = 5000;                       // gépfegyver töltény item újratermelési ideje
  GAME_ITEM_WPN_ROCKETLAUNCHER_RESPAWNTIME = 5000;               // rakéta item újratermelési ideje
  GAME_ITEM_WPN_MCHGUN_AMMO_DEF = 30;                            // gépfegyverhez töltény item ennyi lõszert ad
  GAME_ITEM_WPN_ROCKETLAUNCHER_AMMO_DEF = 5;                     // rakétavetõhöz item ennyi rakétát ad
  GAME_ITEM_QUADDAMAGE_TIME = 20000;                             // ennyi ideig lehet egy playernél a 4x-es sebzés
  GAME_ITEM_QUADDAMAGE_SPEED = 1000;                             // 4x-es sebzés mozgásának sebessége
  GAME_ITEM_QUADDAMAGE_RESPAWNTIME = 30000;                      // 4x-es sebzés újratermelési ideje

  GAME_HUD_HEALTH_MIN = 25;                                      // ennyi életerõ alatt pirosan villog az életerõt jelzõ szám
  GAME_HUD_BLINK_INTERVAL = 200;                                 // villogásnál hány ms-enként váltson színt
  GAME_HUD_ITEMS_TEXT_WAITBEFOREFADE = 1000;                     // hány ms múlva kezdjen el halványodni az item text
  GAME_HUD_ITEMS_TEXT_FADESPEED = 100;                           // milyen gyorsan halványodjon el az item text
  GAME_HUD_MAJORTEXT_WAITBEFOREFADE = 3000;                      // hány ms-ig látszódjon a teleportálás
  GAME_HUD_MAJORTEXT_FADESPEED = 500;                            // milyen gyorsan halványodjon el a teleportálás szöveg

  GAME_INJURYCAUSEDBYFALLING = 30;                               // mennyire legyen nagy az esés okozta sebzés

  GAME_TIMETOREVIVE = 1000;                                      // halál után ennyi ms-et kell várni az újraéledéshez

  GAME_WPN_MAX = 3;                                              // hány különbözõ fegyver van
  GAME_WPN_SCALING = 5;                                          // hány %-ra vannak lekicsinyítve a fegyverek

  GAME_WPN_PISTOL_BULLET_DMG = 8;                               // pisztoly egy lövedéke mennyit sebez
  GAME_WPN_MCHGUN_BULLET_DMG = 5;                               // gépfegyver egy lövedéke mennyit sebez
  GAME_WPN_ROCKETLAUNCHER_BULLET_DMG = 20;                      // rakéta sebzése (ha nem impulse, hanem direkt találat van)
  GAME_BULLET_MOVEMENT_SUBDIVISION = 2;                          // hányszor legyen pontosabb a lövedékek ütközésének sebessége
  GAME_PISTOL_BULLET_SPEED = 40;                                 // pisztoly lövedékének sebessége
  GAME_PISTOL_BULLET_SIZEX = 0.01;                               // pisztoly lövedékének szélessége
  GAME_PISTOL_BULLET_SIZEY = 0.01;                               // pisztoly lövedékének magassága
  GAME_PISTOL_BULLET_SIZEZ = 0.01;                               // pisztoly lövedékének hossza
  GAME_MCHGUN_BULLET_SPEED = 40;                                 // gépfegyver lövedékének sebessége
  GAME_MCHGUN_BULLET_SIZEX = 0.01;                               // gépfegyver lövedékének szélessége
  GAME_MCHGUN_BULLET_SIZEY = 0.01;                               // gépfegyver lövedékének magassága
  GAME_MCHGUN_BULLET_SIZEZ = 0.01;                               // gépfegyver lövedékének hossza
  GAME_ROCKET_SPEED = 13;                                        // rakéta sebessége
  GAME_ROCKET_SCALING = 10;                                      // rakéta objektum méretének skálázási mértéke
  GAME_ROCKET_XPLOSION_STARTSCALE = 10;                          // rakéta okozta robbanás gömbjének kezdeti mérete
  GAME_ROCKET_XPLOSION_STOPSCALE = 200;                          // rakéta okozta robbanás gömbjének végsõ mértéke
  GAME_ROCKET_XPLOSION_SCALESPEED = 8;                           // milyen gyorsan nõjön a robbanás gömbje
  GAME_ROCKET_XPLOSION_IMPULSE_DIST = GAME_ROCKET_XPLOSION_STOPSCALE / 10; // a rakéta becsapódási helyétõl mennyire távolra
                                                                             // hasson a robbanás
  GAME_ROCKET_XPLOSION_IMPULSE = 1;                              // a rakéta robannása okozta lökés ereje
  GAME_ROCKET_XPLOSION_IMPULSE_DMG = 0.1;                        // rakéta okozta sérülés, ha löki a playert
  GAME_ROCKET_SMOKE_SCALESPEED = 200;                            // milyen gyorsan nõjön a füst
  GAME_ROCKET_SMOKE_STOPSCALE = 400;                             // hány %-ra nõjön a füst, mielõtt eltûnik
  GAME_ROCKET_SMOKE_STARTSIZE = 2.0;                             // létrehozásnál mekkora legyen a füst (plane mérete)
  GAME_ROCKET_SMOKE_SPEED = 0.05;                                // milyen gyorsan mozogjon a füst a rakéta irányába

  GAME_WPN_PISTOL_ACCURACY = 5;                                  // pisztoly lövés pontossága
  GAME_WPN_MCHGUN_ACCURACY = 5;                                  // gépfegyver lövés pontossága
  GAME_WPN_ROCKET_ACCURACY = 5;                                  // rakétavetõ lövés pontossága
  
  GAME_WPN_MCHGUN_LCD_ALPHA_MIN = 100;                           // gépfegyver kijelzõjének min. átlátszósága
  GAME_WPN_MCHGUN_LCD_ALPHA_MAX = 150;                           // gépfegyver kijelzõjének max. átlátszósága
  GAME_WPN_MCHGUN_LCD_ALPHA_CHANGESPEED = 8;                     // milyen gyorsan pulzáljon a gépfegyver kijelzõjén a szám
  GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MIN = 40;                     // gépfegyver kijelzõ figyelmeztetõ szöveg kikapcsolva
  GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MAX = 255;                    // gépfegyver kijelzõ figyelmeztetõ szöveg bekapcsolva
  GAME_WPN_MCHGUN_WARNINGNUM = 10;                               // gépfegyver kijelzõ figyelmeztetõ szöveg hány tölténynél jelenik meg

  GAME_MARKS_DISTFROMWALLS = 0.05;                               // milyen távol rakja a faltól a markokat, hogy ne legyen z-bug
  GAME_MARKS_SIZEX = 0.2;                                        // mark szélessége
  GAME_MARKS_SIZEY = 0.2;                                        // mark magassága
  GAME_MARKS_REPOSITIONING_SPEED = 0.05;                         // milyen gyorsan pozícionálja végleges helyre a markokat
  GAME_MARKS_FREEZETIME = 30000;                                 // mennyi idõ múlva kezdjenek el halványodni a markok (ms)

  BOTS_SNAIL_SCALE = 13;                                    // csiga mennyire zsugorodjon alapból betöltés után
  BOTS_ROBOT_SCALE = 25;                                    // robot mennyire zsugorodjon alapból betöltés után
  BOTS_DEATH_YROTSPEED = 100;                                 // bot halálakor forgatási sebesség növelése
  BOTS_DEATH_YROTSPEED_MAX = 0.2;                           // forgatási sebesség max. értéke
  BOTS_DEATH_SCALESPEED = 10;                               // milyen gyorsan zsugorítsa a botot
  BOTS_DEATH_SMOKE_SIZE = 4;                              // mekkora legyen a generált füstök mérete
  BOTS_DMG_BLOOD_SIZE = 1;                                // vér mérete
  BOTS_PATH_MAT_E_NUM_X = 5;                              // a pálya mátrixból ennyi oszlopot lát maga körül a bot
  BOTS_PATH_MAT_E_NUM_Z = BOTS_PATH_MAT_E_NUM_X;          // a pálya mátrixból ennyi sort lát maga körül a bot
  BOTS_DIST_STARTATTACK = 70;                             // milyen távolról kezd el támadni a bot
  BOTS_DIST_ATTACKMAXYDIST = 5;                           // max. ekkora magasság különbségnél támad a bot
  BOTS_TIME_BETWEEN_SHOTS_SNAIL = 500;                    // csiga lövései között eltelt idõ ms-ben
  BOTS_TIME_BETWEEN_SHOTS_ROBOT = 100;                    // robot lövései között eltelt idõ ms-ben
  BOTS_MOVE_SPEED_SNAIL = 20;                             // csiga sebessége
  BOTS_MOVE_SPEED_ROBOT = 15;                             // robot sebessége
  BOTS_SNAIL_ROCKET_START_Y = 2;                          // csiga pozíciójához képest mennyivel magasabban jöjjön létre a kilõtt lövedék
  BOTS_ROBOT_BULLET_START_Y = 1;                          // robot pozíciójához képest mennyivel magasabban jöjjön létre a kilõtt lövedék
  BOTS_FLOATING_SPEED = 20.0;                             // robot lebegési sebessége

  { ************************************************************************************************************* }

  PLAYER_DEFAULTNAME                = 'Névtelen Játékos';        // player alapért. neve
  PLAYER_SIZEX                      = 4.5;                       // player mérete az x-tengelyen
  PLAYER_SIZEY                      = 10.0;                      // player mérete az y-tengelyen
  PLAYER_SIZEZ                      = 4.5;                       // player mérete az z-tengelyen
  PLAYER_MOVE_RUN                   = 90.0;                      // player futási sebessége
  PLAYER_MOVE_WALK                  = 30.0;                      // player sétálási sebessége
  PLAYER_ROTATE                     = 1.0;                       // player fordulási sebessége (iránybillentyûk)

  PLAYER_JUMP_START                 = 4;                         // milyen erõvel hajt felfele minket az ugrás kezdetekor
  PLAYER_MAXXANGLE                  = 85.0;                      // player max. forgásszöge x-tengelyen (ne fordulhasson körbe)
  PLAYER_CAMSHAKE_YPOS              = 15;                        // kamera függõleges rázási sebessége
  PLAYER_CAMSHAKE_YANG              = 7;                         // kamera y-tengelyes irányszöggel való rázási sebessége
  PLAYER_CAMSHAKE_YPOSDIV           = 7;                         // kamera függõleges rázási mértéke
                                                                    // (minél kisebb, annál erõteljesebb a lépés)
  PLAYER_CAMSHAKE_YANGDIV           = 3;                         // kamera y-tengelyes irányszöggel való rázási mértéke
                                                                    // (minél kisebb, annál erõteljesebb a rázás)
  PLAYER_MAX_PASSABLE_HEIGHT_BOXES  = 1.0;                       // max. mennyivel lehet magasabban a player lábától egy
                                                                    // box collision-ös tárgy, h fel lehessen rá lépni
  PLAYER_MAX_PASSABLE_HEIGHT_SLOPES = 0.5;                       // max. mennyivel lehet magasabban a player lábától egy
                                                                    // slope collision-ös tárgy, h fel lehessen rá lépni
  PLAYER_HEADPOSY                   = 3.0;                       // a talaj+PLAYER_SIZEY/2-höz viszonyítva milyen magasságban van
                                                                    // a player feje
  PLAYER_WPN_DEFAULT = 1;                                        // alapért. fegyver, ami a playernél van
  PLAYER_WPN_SHAKE_RATE = 30/29;                                 // mennyire rázza a fegyvert lépés közben függõlegesen,
                                                                    // minél kisebb, annál kevésbé rázza
  PLAYER_WPN_PISTOL_YPOS_BIAS = -0.1;                            // fel-le nézelõdés közben hogyan mozduljon el a pisztoly a
                                                                    // kamerához képest.
                                                                    // =0 = nincs elmozdulás
                                                                    // <0 = felfele nézéskor közeledik, lefele nézéskor távolodik
                                                                    // >0 = felfele nézéskor távolodik, lefele nézéskor közeledik
  PLAYER_WPN_MCHGUN_YPOS_BIAS = -0.1;                            // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_YPOS_BIAS = -0.01;                   // uez rakétavetõnél
  PLAYER_WPN_CHANGE_SPEED = 270;                                 // a fegyverváltás sebessége. Minél nagyobb, annál gyorsabban
                                                                    // váltunk fegyvert
  PLAYER_WPN_CHANGE_ANGLEMAX = 60;                               // fegyver elrakásánál/elõvételénél hány fokkal forgassa el/hány fokról
                                                                    // forgassa vissza az x-tengelyen a fegyvermodellt

  PLAYER_WPN_PISTOL_SHOTZANGLE = -10;                            // mennyire ugorjon fel lövésnél a pisztoly (fok a Z-tengelyen)
  PLAYER_WPN_MCHGUN_SHOTZANGLE = -1;                             // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLE = -10;                    // uez rakétavetõnél
  PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEED = 300;                 // milyen gyorsan ugorjon fel lövéskor a pisztoly
  PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEED = 100;                 // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEED = 200;         // uez rakétavetõnél
  PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEEDAFTER = 60;             // milyen gyorsan húzza vissza a kéz a pisztolyt lövés után
  PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEEDAFTER = 20;             // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEEDAFTER = 20;     // uez rakétavetõnél
  PLAYER_WPN_MCHGUN_TIMEBETWEENSHOTS = 100;                      // hány ms-nek kell eltelnie két lövés között gépfegyvernél
  PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEED = 180;                 // egy lövés mennyire fordítja el a gépfegyvert
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLECHANGESPEED = 180;         // uez raksinál
  PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEEDAFTER = 20;             // milyen gyorsan húzom vissza középre a gépfegyvert lövés után
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLECHANGESPEEDAFTER = 20;     // uez raksinál
  PLAYER_WPN_MCHGUN_SHOTYANGLE_MAX = 3;                          // max hány fokig fordulhat el a gépfegyver lövésnél
  PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLE_MAX = 3;                  // uez raksinál

  PLAYER_WPN_PISTOL_RELOADZANGLE = 0;                            // újratöltésnél mennyire fordítsa le a fegyvert
  PLAYER_WPN_MCHGUN_RELOADZANGLE = 0;                            // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLE = 20;                   // uez raksinál
  PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEED = 0;                 // milyen gyorsan fordítsa le újratöltésnél a pisztolyt
  PLAYER_WPN_MCHUGN_RELOADZANGLECHANGESPEED = 0;                 // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEED = 60;        // uez rakétavetõnél
  PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEEDAFTER = 0;            // újratöltés után milyen gyorsan húzza vissza a pisztolyt
  PLAYER_WPN_MCHGUN_RELOADZANGLECHANGESPEEDAFTER = 0;            // uez gépfegyvernél
  PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEEDAFTER = 60;   // uez rakétavetõnél
  PLAYER_WPN_ROCKETLAUNCHER_TIME_BETWEEN_RELOAD_STEPS = 500;     // rakétavetõ újratöltésénél hány ms-et várjon 1-1 raksi
                                                                    // betöltése között
  PLAYER_WPN_ROCKETLAUNCHER_STEPS_TO_SHOW_COUNT = 10;            // hány elmozdítás után tegyük láthatóvá a rakétát
                                                                    // (hogy ne látszódjon, h a fejüknbõl jön ki)

implementation

end.
