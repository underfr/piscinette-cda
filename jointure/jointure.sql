-- Jointure user + role
SELECT 
    u.id_users,
    u.nickname,
    u.email,
    r.name AS role
FROM users u
INNER JOIN roles r ON u.id_role = r.id_role;

-- Jointure plantes d'un utilisateur
SELECT 
    u.nickname,
    p.name AS plante,
    p.species,
    p.water_quantity,
    p.frequency
FROM plants p
INNER JOIN users u ON p.id_user = u.id_users
WHERE u.id_users = 1;


-- Tracker actuel
SELECT 
    p.name AS plante,
    t.measure,
    t.watering,
    t.tracker_date
FROM tracker t
INNER JOIN plants p ON t.id_plant = p.id_plant
WHERE p.id_plant = 1;

-- Historique complet (timeline)
SELECT 
    p.name AS plante,
    tt.measure,
    tt.watering,
    tt.tracker_date
FROM tracker_timeline tt
INNER JOIN plants p ON tt.id_plant = p.id_plant
WHERE p.id_plant = 1
ORDER BY tt.tracker_date DESC;

-- Soins d'une plante
SELECT 
    p.name AS plante,
    c.care_date,
    c.height,
    c.repotting,
    c.fertilization
FROM care c
INNER JOIN plants p ON c.id_plant = p.id_plant
WHERE p.id_plant = 1
ORDER BY c.care_date DESC;

-- Message privé entre amis
SELECT 
    sender.nickname AS expediteur,
    receiver.nickname AS destinataire,
    pm.message,
    pm.created_at
FROM private_message pm
INNER JOIN users sender ON pm.id_sender = sender.id_users
INNER JOIN users receiver ON pm.id_receiver = receiver.id_users
INNER JOIN friends f ON pm.id_friend = f.id_friend
WHERE f.id_friend = 1
ORDER BY pm.created_at ASC;

-- Liste amis d'un utilisateur avec leur statut
SELECT 
    u1.nickname AS utilisateur,
    u2.nickname AS ami,
    f.status,
    f.created_at
FROM friends f
INNER JOIN users u1 ON f.id_user1 = u1.id_users
INNER JOIN users u2 ON f.id_user2 = u2.id_users
WHERE f.id_user1 = 1 
   OR f.id_user2 = 1;

-- Post forum avec auteur + moyenne des notes
SELECT 
    fp.name AS titre,
    u.nickname AS auteur,
    fp.created_at,
    COUNT(DISTINCT fc.id_comment) AS nb_commentaires,
    ROUND(AVG(fr.rating), 1) AS note_moyenne
FROM forum_post fp
INNER JOIN users u ON fp.id_user = u.id_users
LEFT JOIN forum_comment fc ON fp.id_post = fc.id_post
LEFT JOIN forum_review fr ON fp.id_post = fr.id_post
GROUP BY fp.id_post, fp.name, u.nickname, fp.created_at
ORDER BY fp.created_at DESC;

-- Commentaires d'un post avec auteurs
SELECT 
    fp.name AS post,
    u.nickname AS auteur_commentaire,
    fc.description AS commentaire,
    fc.created_at
FROM forum_comment fc
INNER JOIN users u ON fc.id_user = u.id_users
INNER JOIN forum_post fp ON fc.id_post = fp.id_post
WHERE fp.id_post = 1
ORDER BY fc.created_at ASC;

-- Conseils liés à une plante
SELECT 
    p.name AS plante,
    h.name AS conseil,
    h.description,
    h.link,
    u.nickname AS auteur_conseil
FROM hints_plants hp
INNER JOIN plants p ON hp.id_plant = p.id_plant
INNER JOIN hints h ON hp.id_hint = h.id_hint
INNER JOIN users u ON h.id_user = u.id_users
WHERE p.id_plant = 1;

-- Vue complète d'une plante
SELECT 
    u.nickname AS proprietaire,
    p.name AS plante,
    p.species,
    p.water_quantity,
    p.frequency,
    t.measure AS mesure_actuelle,
    t.watering AS arrosage_actuel,
    c.height AS derniere_hauteur,
    c.repotting AS rempotage,
    c.fertilization AS fertilisation
FROM plants p
INNER JOIN users u ON p.id_user = u.id_users
LEFT JOIN tracker t ON p.id_plant = t.id_plant
LEFT JOIN care c ON p.id_plant = c.id_plant
WHERE p.id_plant = 1
ORDER BY c.care_date DESC
LIMIT 1;