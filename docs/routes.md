# 📚 API Routes – tilt

Ce fichier documente l’ensemble des routes disponibles pour l’API REST de l’application tilt.

---

## 🛡️ Authentification

| Méthode | Route                  | Description                             |
|---------|------------------------|-----------------------------------------|
| POST    | `/auth/register`       | Inscription (client ou commerçant)      |
| POST    | `/auth/login`          | Connexion                               |
| POST    | `/auth/logout`         | Déconnexion                             |
| POST    | `/auth/refresh-token`  | Rafraîchir le token JWT                 |
| POST    | `/auth/verify-code`    | Vérification du code secret (2FA)       |
| POST    | `/auth/set-code`       | Mettre  le code secret du commerçant    |
| POST    | `/auth/forgot-password`| Réinitialisation de mot de passe        |

---

## 👤 Utilisateurs

| Méthode | Route                                           | Description                                        |
|---------|-------------------------------------------------|----------------------------------------------------|
| GET     | `/utilisateurs/:id`                             | Voir un utilisateur                                |
| PUT     | `/utilisateurs/:id`                             | Modifier son profil                                |
| DELETE  | `/utilisateurs/:id`                             | Supprimer un utilisateur                           |
| POST    | `/utilisateurs/:id/avatar`                      | Pour envoyer ou modifier une photo de profil       |
| GET     | `GET /utilisateurs/:id/magasins`                | Pour un commerçant, voir ses magasins              |
| GET     | `GET /utilisateurs/:id/recompenses-utilisees`   | historique des récompenses utilisées               |
| GET     | `GET /utilisateurs/:id/notifications`           | Pour les notifs                                    |
| GET     | `GET /utilisateurs/:id/avis`                    |  Tous les avis postés                              |
| GET     | `/utilisateurs/:id/badges`                      | Voir les badges obtenus                            |
| GET     | `/utilisateurs/:id/points`                      | Voir tous les soldes de points                     |

---

## 🏪 Magasins

| Méthode | Route                            | Description                                                                  |
|---------|----------------------------------|------------------------------------------------------------------------------|
| GET     | `/magasins`                      | Lister tous les magasins                                                     |
| POST    | `/magasins`                      | Créer un magasin (par commerçant)                                            |
| GET     | `/magasins/:id`                  | Voir un magasin                                                              |
| PUT     | `/magasins/:id`                  | Modifier un magasin                                                          |
| DELETE  | `/magasins/:id`                  | Supprimer un magasin                                                         |
| GET     | `/magasins/:id/avis`             | Voir les avis                                                                |
| GET     | `/magasins/:id/programme`        | Voir le programme fidélité associé                                           |
| GET     | `/magasins/:id/clients`          | Liste des clients avec des points ou achats dans ce magasin.                 |
| GET     | `/magasins/:id/recompenses`      | Toutes les récompenses disponibles                                           |
| GET     | `/magasins/:id/points/:idClient` | Solde de points d’un client pour ce magasin (utile côté commerçant)          |
| POST    | `/magasins/:id/scan`             | endpoint pour qu’un commerçant scanne un QR ou téléphone et crédite un achat |

---

## 🎁 Programmes & Récompenses

| Méthode | Route                                 | Description                              |
|---------|----------------------------------------|------------------------------------------|
| GET     | `/programmes/:id`                     | Voir un programme de fidélité            |
| POST    | `/programmes`                         | Créer un programme                       |
| PUT     | `/programmes/:id`                     | Modifier un programme                    |
| GET     | `/recompenses`                        | Lister toutes les récompenses            |
| POST    | `/recompenses`                        | Ajouter une récompense                   |
| GET     | `/magasins/:id/recompenses`           | Récompenses d’un magasin                 |
| POST    | `/recompenses/:id/utiliser`           | Utiliser une récompense                  |

---

## 🛍️ Achats & Points

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| POST    | `/achats`                             | Enregistrer un achat                   |
| GET     | `/utilisateurs/:id/achats`            | Voir l’historique d’achats             |
| GET     | `/magasins/:id/achats`                | Historique des achats d’un magasin     |
| GET     | `/utilisateurs/:id/points/:magasinId` | Voir les points dans un magasin donné  |
| POST    | `/points`                             | Mettre à jour/créditer des points      |

---

## 💳 Abonnements & Paiements

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| GET     | `/abonnements/:id`                    | Détails d’un abonnement                |
| POST    | `/abonnements`                        | Démarrer un abonnement                 |
| PUT     | `/abonnements/:id`                    | Modifier ou annuler un abonnement      |
| POST    | `/paiements/webhook`                  | Webhook Stripe                         |

---

## 🧾 Avis

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| POST    | `/avis`                               | Laisser un avis                        |
| GET     | `/magasins/:id/avis`                 | Voir les avis d’un magasin             |
| DELETE  | `/avis/:id`                          | Supprimer un avis                      |

---

## 🔔 Notifications

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| GET     | `/utilisateurs/:id/notifications`     | Voir les notifications                 |
| POST    | `/notifications`                      | Envoyer une notification               |
| PATCH   | `/notifications/:id/lu`               | Marquer comme lue                      |

---

## 🧭 QR Codes

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| GET     | `/utilisateurs/:id/qrcode`            | Récupérer le QR code actif             |
| POST    | `/qrcode`                             | Générer un nouveau QR code             |

---

## 🤝 Parrainage

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| POST    | `/parrainage`                         | Ajouter un parrainage                  |
| GET     | `/utilisateurs/:id/parrainages`       | Voir ses filleuls                      |

---

## 🏅 Badges

| Méthode | Route                                 | Description                            |
|---------|----------------------------------------|----------------------------------------|
| GET     | `/badges`                             | Lister tous les badges                 |
| GET     | `/utilisateurs/:id/badges`            | Voir les badges obtenus                |

---

**Dernière mise à jour** : 2025-06-21
