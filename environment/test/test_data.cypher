MATCH (n) DETACH DELETE n;

CREATE (id:GlobalUniqueId { count:1000 });

CREATE (n:User:Active { id:1 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Adam", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 1 CREATE (a)-[:Is]->(n:Player:Active { id:10 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Erlango" });

CREATE (n:User:Active { id:2 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Bertil", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 2 CREATE (a)-[:Is]->(n:Player:Active { id:11 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Erik" });

CREATE (n:User:Active { id:3 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Ceasar", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 3 CREATE (a)-[:Is]->(n:Player:Active { id:12 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Filip" });

MATCH (a:Player) WHERE a.id = 10 CREATE (a)-[:Constructed]->(n:Deck:Active { id:20 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 1", format:"STANDARD", theme:"Testing", black:true, white:true, red:false, green:false, blue:false, colorless:false});
MATCH (a:Player) WHERE a.id = 10 CREATE (a)-[:Constructed]->(n:Deck:Active { id:21 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 2", format:"PAUPER", theme:"Testing", black:true, white:true, red:true, green:true, blue:true, colorless:true});
MATCH (a:Player) WHERE a.id = 11 CREATE (a)-[:Constructed]->(n:Deck:Active { id:22 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 3", format:"BOOSTER_HANDOVER", theme:"Testing", black:false, white:false, red:false, green:false, blue:false, colorless:false});
MATCH (a:Player) WHERE a.id = 12 CREATE (a)-[:Constructed]->(n:Deck:Active { id:23 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 4", format:"MODERN", theme:"Testing", black:false, white:false, red:true, green:false, blue:false, colorless:false});

MATCH (a:Player) WHERE a.id = 11 CREATE (a)-[:Created]->(g:Game { id:40, created:TIMESTAMP(), conclusion:"VICTORY" });
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 20 AND g.id = 40 AND p.id = 10 CREATE (p)-[:Got]->(r:Result { id:30, created:TIMESTAMP(), place:1, comment:"First result" })-[:With]->(d),(r)-[:In]->(g);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 22 AND g.id = 40 AND p.id = 11 CREATE (p)-[:Got]->(r:Result { id:31, created:TIMESTAMP(), place:2, comment:"Second result" })-[:With]->(d),(r)-[:In]->(g);

MATCH (a:Player) WHERE a.id = 12 CREATE (a)-[:Created]->(g:Game { id:41, created:TIMESTAMP(), conclusion:"VICTORY" });
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 20 AND g.id = 41 AND p.id = 10 CREATE (p)-[:Got]->(r:Result { id:32, created:TIMESTAMP(), place:1, comment:"Third result" })-[:With]->(d),(r)-[:In]->(g);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 23 AND g.id = 41 AND p.id = 11 CREATE (p)-[:Got]->(r:Result { id:33, created:TIMESTAMP(), place:2, comment:"Fourth result" })-[:With]->(d),(r)-[:In]->(g);

MATCH (a:Player) WHERE a.id = 12 CREATE (a)-[:Created]->(g:Game { id:42, created:TIMESTAMP(), conclusion:"VICTORY" });


MATCH (a:Player) WHERE a.id = 10 CREATE (a)-[:Created]->(g:Match { id:50, created:TIMESTAMP() });
MATCH (a:Player), (m:Match), (d:Deck) WHERE a.id = 10 AND m.id = 50 AND d.id = 20 CREATE (a)-[:Was]->(p:Participant { id: 60, number: 1 })-[:In]->(m), (p)-[:Used]->(d);
MATCH (a:Player), (m:Match), (d:Deck) WHERE a.id = 11 AND m.id = 50 AND d.id = 22 CREATE (a)-[:Was]->(p:Participant { id: 61, number: 2 })-[:In]->(m), (p)-[:Used]->(d);

MATCH (a:Player), (m:Match) WHERE a.id = 10 AND m.id = 50 CREATE (a)-[:Created]->(g:Game { id:43, created:TIMESTAMP(), conclusion:"VICTORY" })<-[:Contains]-(m);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 20 AND g.id = 43 AND p.id = 10 CREATE (p)-[:Got]->(r:Result { id:34, created:TIMESTAMP(), place:1, comment:"First result first game first match" })-[:With]->(d),(r)-[:In]->(g);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 23 AND g.id = 43 AND p.id = 11 CREATE (p)-[:Got]->(r:Result { id:35, created:TIMESTAMP(), place:2, comment:"Second result first game first match" })-[:With]->(d),(r)-[:In]->(g);

MATCH (a:Player), (m:Match) WHERE a.id = 10 AND m.id = 50 CREATE (a)-[:Created]->(g:Game { id:44, created:TIMESTAMP(), conclusion:"VICTORY" })<-[:Contains]-(m);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 20 AND g.id = 44 AND p.id = 10 CREATE (p)-[:Got]->(r:Result { id:36, created:TIMESTAMP(), place:2, comment:"First result second game first match" })-[:With]->(d),(r)-[:In]->(g);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 23 AND g.id = 44 AND p.id = 11 CREATE (p)-[:Got]->(r:Result { id:37, created:TIMESTAMP(), place:1, comment:"Second result second game first match" })-[:With]->(d),(r)-[:In]->(g);

MATCH (a:Player), (m:Match) WHERE a.id = 10 AND m.id = 50 CREATE (a)-[:Created]->(g:Game { id:45, created:TIMESTAMP(), conclusion:"VICTORY" })<-[:Contains]-(m);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 20 AND g.id = 45 AND p.id = 10 CREATE (p)-[:Got]->(r:Result { id:38, created:TIMESTAMP(), place:1, comment:"First result third game first match" })-[:With]->(d),(r)-[:In]->(g);
MATCH (d:Deck), (g:Game), (p:Player) WHERE d.id = 23 AND g.id = 45 AND p.id = 11 CREATE (p)-[:Got]->(r:Result { id:39, created:TIMESTAMP(), place:2, comment:"Second result third game first match" })-[:With]->(d),(r)-[:In]->(g);
