-- =====================================================
-- SEED.SQL - Base de données Plantes
-- Données de test réalistes pour le schéma plantes
-- =====================================================

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT=0;
START TRANSACTION;

-- =====================================================
-- SECTION 1: ROLES (3 entrées)
-- =====================================================
INSERT INTO roles (id_role, name) VALUES
(1, 'admin'),
(2, 'user'),
(3, 'moderator');

-- =====================================================
-- SECTION 2: USERS (6 utilisateurs français)
-- =====================================================
INSERT INTO users (id_users, name, firstname, nickname, email, password, created_at, id_role) VALUES
(1, 'Dupont', 'Marie', 'MarieJardin', 'marie.dupont@email.fr', '$2y$10$xK8mN5pQ7rS9tU2vW3xYZeOPqR6sTuL0vJ8kM2nC4dE5fG6hI7jK8', '2024-01-15 08:30:00', 2),
(2, 'Martin', 'Pierre', 'PierrePlante', 'pierre.martin@email.fr', '$2y$10$yL9nO6rT8sT0uV1wX2yAZfPQqS7tUuM1wK9lN3oD5eF6gH7hI8jK9', '2024-02-20 14:22:00', 2),
(3, 'Bernard', 'Sophie', 'SophieNature', 'sophie.bernard@email.fr', '$2y$10$zM0oP7sU9tT1uV2wY3zBAgQRrT8tVvN2xL0oM4pE6fG7hI8iJ9kK0', '2024-03-10 09:15:00', 3),
(4, 'Thomas', 'Lucas', 'LucasVerdure', 'lucas.thomas@email.fr', '$2y$10$aN1pQ8tV0uT2vW3xY4aCHRSsU9tWwO3yM1pN5qF7gH8iI9jJ0kK1', '2024-04-05 16:45:00', 2),
(5, 'Robert', 'Emma', 'EmmaGreen', 'emma.robert@email.fr', '$2y$10$bO2qR9uW1vT3wX4yZ5bDISRtV0uXxP4zN2qO6rG8hI9jJ0kK1lL2', '2024-05-18 11:30:00', 2),
(6, 'Petit', 'Hugo', 'HugoBotanique', 'hugo.petit@email.fr', '$2y$10$cP3rS0vX2wT4xY5zA6cEJTStW1vYyQ5aO3rP7sH9iJ0kK1lL2mM3', '2024-06-01 20:00:00', 1);

-- =====================================================
-- SECTION 3: FRIENDS (5 amitiés)
-- Règle: id_user1 < id_user2 (chk_order respectée)
-- =====================================================
INSERT INTO friends (id_friend, id_user1, id_user2, status, created_at) VALUES
(1, 1, 2, 'accepted', '2024-03-01 10:00:00'),  -- Marie <-> Pierre
(2, 1, 3, 'accepted', '2024-03-15 14:30:00'),  -- Marie <-> Sophie
(3, 2, 4, 'pending', '2024-04-10 09:00:00'),    -- Pierre -> Lucas (en attente)
(4, 3, 5, 'accepted', '2024-04-20 11:15:00'),  -- Sophie <-> Emma
(5, 4, 6, 'accepted', '2024-05-05 16:00:00');   -- Lucas <-> Hugo

-- =====================================================
-- SECTION 4: PRIVATE_MESSAGES (10 messages)
-- Contraintes: id_sender != id_receiver
-- id_friend DOIT référencer une amitié acceptée entre ces 2 users
-- =====================================================
INSERT INTO private_message (id_private_message, message, created_at, id_sender, id_receiver, id_friend) VALUES
(1, 'Salut Pierre ! Ton monstera pousse toujours aussi bien ?', '2024-03-02 18:00:00', 1, 2, 1),
(2, 'Oui super bien ! Il a fait de nouvelles feuilles cette semaine.', '2024-03-02 19:30:00', 2, 1, 1),
(3, 'Tu conseilles quoi comme engrais pour les pothos ?', '2024-03-16 10:00:00', 1, 3, 2),
(4, 'J''utilise un engrais liquide 20% toutes les 2 semaines.', '2024-03-16 11:30:00', 3, 1, 2),
(5, 'Merci pour le tuyau ! Je vais essayer.', '2024-03-16 12:00:00', 1, 3, 2),
(6, 'Sophie, tu connais un bon terreau pour orchidées ?', '2024-04-22 09:00:00', 5, 3, 4),
(7, 'Oui je recommande le substrat spécial orchidées avec des éclats de bois.', '2024-04-22 10:15:00', 3, 5, 4),
(8, 'Super idée le pot transparent pour vérifier les racines !', '2024-04-22 14:00:00', 5, 3, 4),
(9, 'Lucas, ton basilic a survécu à l''été dernier ?', '2024-05-10 08:00:00', 6, 4, 5),
(10, 'Oui simple ! Un arrosage quotidien et beaucoup de soleil.', '2024-05-10 09:00:00', 4, 6, 5);

-- =====================================================
-- SECTION 5: PLANTS (8 plantes variées)
-- UNIQUE par user (pas de contrainte globale name+species)
-- =====================================================
INSERT INTO plants (id_plant, name, species, buy_at, image, water_quantity, frequency, id_user) VALUES
(1, 'Monstera Deliciosa', 'Monstera deliciosa', '2023-06-15 10:00:00', '/images/monstera.jpg', 0.50, 'hebdomadaire', 1),
(2, 'Pothos Doré', 'Epipremnum aureum', '2023-08-20 14:00:00', '/images/pothos.jpg', 0.30, 'bi-hebdomadaire', 1),
(3, 'Cactus Boule', 'Echinocactus grusonii', '2023-04-10 09:00:00', '/images/cactus.jpg', 0.10, 'mensuel', 2),
(4, 'Ficus Lyrata', 'Ficus lyrata', '2024-01-05 11:00:00', '/images/ficus.jpg', 0.40, 'hebdomadaire', 2),
(5, 'Orchidée Phalaenopsis', 'Phalaenopsis hybrid', '2023-09-12 15:00:00', '/images/orchid.jpg', 0.20, 'hebdomadaire', 3),
(6, 'Lavande Vraie', 'Lavandula angustifolia', '2024-02-28 10:00:00', '/images/lavender.jpg', 0.25, 'hebdomadaire', 4),
(7, 'Rosier Grimpant', 'Rosa banksiae', '2023-03-20 08:00:00', '/images/rose.jpg', 0.60, 'quotidien', 5),
(8, 'Basilic Grand Vert', 'Ocimum basilicum', '2024-05-01 09:00:00', '/images/basilic.jpg', 0.35, 'quotidien', 6);

-- =====================================================
-- SECTION 6: TRACKER_TIMELINE (historique - 15 entrées)
-- à insérer AVANT tracker pour simuler l''historique
-- =====================================================
INSERT INTO tracker_timeline (id_timeline, measure, tracker_date, watering, id_plant) VALUES
-- Historique Monstera (3 mesures)
(1, 45.50, '2024-01-01 10:00:00', '500ml avec engrais', 1),
(2, 52.30, '2024-02-15 10:00:00', '500ml', 1),
(3, 58.00, '2024-03-20 10:00:00', '500ml', 1),
-- Historique Pothos (2 mesures)
(4, 25.00, '2024-02-01 11:00:00', '300ml', 2),
(5, 30.50, '2024-03-15 11:00:00', '300ml', 2),
-- Historique Cactus (2 mesures)
(6, 15.00, '2023-06-01 09:00:00', '100ml', 3),
(7, 16.20, '2023-09-01 09:00:00', '100ml', 3),
-- Historique Ficus (2 mesures)
(8, 40.00, '2024-02-01 11:00:00', '400ml', 4),
(9, 45.00, '2024-04-01 11:00:00', '400ml', 4),
-- Historique Orchidée (2 mesures)
(10, 35.00, '2023-11-01 15:00:00', '200ml', 5),
(11, 36.50, '2024-02-01 15:00:00', '200ml', 5),
-- Historique Lavande (2 mesures)
(12, 20.00, '2024-03-15 10:00:00', '250ml', 6),
(13, 25.00, '2024-05-01 10:00:00', '250ml', 6),
-- Historique Rosier (1 mesure)
(14, 80.00, '2023-06-01 08:00:00', '600ml', 7),
-- Historique Basilic (1 mesure)
(15, 15.00, '2024-05-15 09:00:00', '350ml', 8);

-- =====================================================
-- SECTION 7: TRACKER (entretien ACTUEL - 8 entrées)
-- UN SEUL enregistrement par plante
-- =====================================================
INSERT INTO tracker (id_tracker, measure, tracker_date, watering, id_plant) VALUES
(1, 65.50, '2024-06-10 10:00:00', '500ml avec engrais organique', 1),
(2, 35.00, '2024-06-08 11:00:00', '300ml', 2),
(3, 17.00, '2024-06-01 09:00:00', '100ml', 3),
(4, 50.00, '2024-06-05 11:00:00', '400ml', 4),
(5, 38.00, '2024-06-12 15:00:00', '200ml special orchidées', 5),
(6, 30.00, '2024-06-10 10:00:00', '250ml', 6),
(7, 95.00, '2024-06-15 08:00:00', '600ml', 7),
(8, 22.00, '2024-06-16 09:00:00', '350ml', 8);

-- =====================================================
-- SECTION 8: CARE (12 entrées d''entretien)
-- =====================================================
INSERT INTO care (id_care, care_date, height, repotting, fertilization, id_plant) VALUES
(1, '2024-03-01 10:00:00', 65.50, true, true, 1),
(2, '2024-04-01 10:00:00', 70.00, false, true, 1),
(3, '2024-02-15 11:00:00', 35.00, false, true, 2),
(4, '2024-03-20 11:00:00', 38.00, true, false, 2),
(5, '2023-08-01 09:00:00', 17.00, false, false, 3),
(6, '2024-02-01 11:00:00', 50.00, true, true, 4),
(7, '2024-04-01 11:00:00', 55.00, false, true, 4),
(8, '2024-01-15 15:00:00', 38.00, true, false, 5),
(9, '2024-05-01 10:00:00', 30.00, true, true, 6),
(10, '2023-07-01 08:00:00', 95.00, false, true, 7),
(11, '2024-04-01 08:00:00', 110.00, true, true, 7),
(12, '2024-06-01 09:00:00', 22.00, false, true, 8);

-- =====================================================
-- SECTION 9: HINTS (6 conseils - name UNIQUE)
-- =====================================================
INSERT INTO hints (id_hint, name, description, link, id_user) VALUES
(1, 'Arrosage optimal', 'Laissez sécher le terreau entre deux arrosages pour éviter le pourridié.', 'https://conseils-jardinage.fr/arrosage', 1),
(2, 'Rempotage.printemps', 'Le meilleur moment pour rempoter est au printemps quand la croissance reprend.', 'https://conseils-jardinage.fr/rempotage', 2),
(3, 'Engrais.naturel', 'Utilisez du marc de café comme engrais naturel riche en azote.', 'https://conseils-jardinage.fr/engrais-naturel', 3),
(4, 'Humidité.plantes', 'Groupez vos plantes pour créer un microclimat humide naturellement.', 'https://conseils-jardinage.fr/humidite', 4),
(5, 'Taille.facil', 'Taillez toujours avec des outils propres et désinfectés.', 'https://conseils-jardinage.fr/taille', 5),
(6, 'Lumière.adaptée', 'Observez les signes de votre plante : feuilles qui jaunissent indiquent souvent trop ou pas assez de lumière.', 'https://conseils-jardinage.fr/lumiere', 6);

-- =====================================================
-- SECTION 10: HINTS_PLANTS (10 associations)
-- =====================================================
INSERT INTO hints_plants (id_plant, id_hint) VALUES
(1, 1),  -- Monstera + Arrosage optimal
(1, 2),  -- Monstera + Rempotage
(2, 3),  -- Pothos + Engrais naturel
(2, 4),  -- Pothos + Humidité
(3, 2),  -- Cactus + Rempotage
(4, 5),  -- Ficus + Taille
(5, 6),  -- Orchidée + Lumière
(5, 2),  -- Orchidée + Rempotage
(6, 1),  -- Lavande + Arrosage
(8, 3);  -- Basilic + Engrais naturel

-- =====================================================
-- SECTION 11: FORUM_POST (6 posts - name UNIQUE)
-- =====================================================
INSERT INTO forum_post (id_post, name, description, img, created_at, id_user) VALUES
(1, 'Mon monstera ne fait pas de trous', 'Bonjour, ma Monstera deliciosa a 3 ans mais les feuilles restent sans trous. Est-ce normal ? J''ai boa lumière et j''arrose quand le terreau sèche.', '/images/forum/monstera-sans-trous.jpg', '2024-05-10 14:30:00', 1),
(2, 'Orchidée fanée que faire', 'Mon orchidée a perdu toutes ses fleurs. Faut-il couper la tige ? Comment la faire refleurir ?', '/images/forum/orchidee-fanee.jpg', '2024-05-15 09:00:00', 3),
(3, 'Cactus qui jaunit', 'Mon cactus devient jaune à la base. Est-ce une pourriture ? Je l''arrose 1 fois par mois maximum.', '/images/forum/cactus-jaune.jpg', '2024-05-20 16:00:00', 2),
(4, 'Basilic qui monte en graine', 'Mon basilic monte en graine très vite, les feuilles deviennent amères. Comment éviter ça ?', '/images/forum/basilic-graines.jpg', '2024-06-01 08:00:00', 6),
(5, 'Ficus perd ses feuilles', 'Mon Ficus lyrata perd beaucoup de feuilles depuis que je l''ai déplacé. Est-ce le courant d''air ?', '/images/forum/ficus-perd-feuilles.jpg', '2024-06-05 11:00:00', 2),
(6, 'Lavande envahie par les pucerons', 'Ma lavande est couverte de pucerons noirs. Remedy naturel svp ?', '/images/forum/lavande-pucerons.jpg', '2024-06-10 15:30:00', 4);

-- =====================================================
-- SECTION 12: FORUM_COMMENT (15 commentaires)
-- =====================================================
INSERT INTO forum_comment (id_comment, description, id_user, id_post, created_at) VALUES
(1, 'C''est souvent dû à un manque de lumière. Essaie de la mettre près d''une fenêtre orientée Est.', 2, 1, '2024-05-10 15:00:00'),
(2, 'As-tu augmenté la luminosité récemment ? Les feuilles s''adaptent mais les trous prennent du temps.', 3, 1, '2024-05-10 16:30:00'),
(3, 'Coupe la tige à 2 cm du bulbe après la deuxième fleur en partant du bas !', 1, 2, '2024-05-15 10:00:00'),
(4, 'Patience ! Mon orchidée a mis 8 mois avant de refleurir. Un apport d''engrais orchidées aide.', 2, 2, '2024-05-15 11:30:00'),
(5, 'Met-la dans un substrat cactus et stoppe l''arrosage pendant 3 semaines.', 4, 3, '2024-05-20 17:00:00'),
(6, 'Vérifie les racines : si elles sont molles et brunes, c''est la pourriture.', 3, 3, '2024-05-20 18:00:00'),
(7, 'Coupe les tiges florales dès qu''elles apparaissent pour favoriser les feuilles.', 5, 4, '2024-06-01 09:00:00'),
(8, 'Pince régulièrement les bourgeons floraux, çastimule la croissance des feuilles.', 6, 4, '2024-06-01 10:00:00'),
(9, 'Le ficus déteste les courants d''air ! Remets-le à sa place d''origine.', 1, 5, '2024-06-05 12:00:00'),
(10, 'Attends 2-3 semaines pour qu''il s''acclimate. Il perd des feuilles quand il stress.', 5, 5, '2024-06-05 14:00:00'),
(11, 'Pulvérise un mélange d''eau et de savon noir, ça marche très bien !', 2, 6, '2024-06-10 16:00:00'),
(12, 'Les coccinelles adorent les pucerons, essaie d''en attirer dans ton jardin.', 3, 6, '2024-06-10 17:00:00'),
(13, 'Merci pour ces conseils ! Je vais essayer le savon noir ce soir.', 4, 6, '2024-06-10 18:00:00'),
(14, 'Belle plante ! Les trous vont finir par apparaître avec le temps.', 6, 1, '2024-05-11 09:00:00'),
(15, 'Un lumineux aide aussi à accélérer l''apparition des fenestrations.', 5, 1, '2024-05-11 10:00:00');

-- =====================================================
-- SECTION 13: FORUM_REVIEW (8 avis - rating DECIMAL(2,1))
-- =====================================================
INSERT INTO forum_review (id_review, rating, description, created_at, id_user, id_post) VALUES
(1, 4.5, 'Super topic, j''ai résolu mon problème grâce aux conseils !', '2024-05-11 10:00:00', 3, 1),
(2, 5.0, 'Les photos sont très claires, merci pour le partage !', '2024-05-16 14:00:00', 1, 2),
(3, 3.5, 'Bien mais j''aurais aimé plus de détails sur le rempotage.', '2024-05-21 09:00:00', 5, 3),
(4, 4.0, 'Ça a marché pour mon basilic, merci !', '2024-06-02 11:00:00', 2, 4),
(5, 2.0, 'Pas d''accord avec le conseil sur l''engrais pour ficus.', '2024-06-06 15:00:00', 6, 5),
(6, 4.5, 'Le truc du savon noir fonctionne bien !', '2024-06-11 10:00:00', 1, 6),
(7, 3.0, 'Correct mais pas assez de photos pour illustrer.', '2024-05-12 16:00:00', 4, 1),
(8, 4.0, 'J''ai testé et ça a bien marché pour mon orchidée.', '2024-05-17 12:00:00', 6, 2);

-- =====================================================
-- VALIDATION ET FINALISATION
-- =====================================================
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

-- =====================================================
-- VÉRIFICATIONS
-- =====================================================
-- SELECT 'Roles:' as info, COUNT(*) as total FROM roles;
-- SELECT 'Users:' as info, COUNT(*) as total FROM users;
-- SELECT 'Friendships:' as info, COUNT(*) as total FROM friends;
-- SELECT 'Private messages:' as info, COUNT(*) as total FROM private_message;
-- SELECT 'Plants:' as info, COUNT(*) as total FROM plants;
-- SELECT 'Tracker (current):' as info, COUNT(*) as total FROM tracker;
-- SELECT 'Tracker timeline (history):' as info, COUNT(*) as total FROM tracker_timeline;
-- SELECT 'Care records:' as info, COUNT(*) as total FROM care;
-- SELECT 'Hints:' as info, COUNT(*) as total FROM hints;
-- SELECT 'Hints-Plants links:' as info, COUNT(*) as total FROM hints_plants;
-- SELECT 'Forum posts:' as info, COUNT(*) as total FROM forum_post;
-- SELECT 'Forum comments:' as info, COUNT(*) as total FROM forum_comment;
-- SELECT 'Forum reviews:' as info, COUNT(*) as total FROM forum_review;