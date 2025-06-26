-- CreateEnum
CREATE TYPE "tilt_schema"."TypeUtilisateur" AS ENUM ('admin', 'client', 'commercant');

-- CreateEnum
CREATE TYPE "tilt_schema"."TypeRecompense" AS ENUM ('montant_fixe', 'pourcentage', 'objet');

-- CreateEnum
CREATE TYPE "tilt_schema"."StatutAbonnement" AS ENUM ('essai', 'actif', 'expiré', 'annulé');

-- CreateEnum
CREATE TYPE "tilt_schema"."TypeAbonnement" AS ENUM ('mensuel', 'annuel');

-- CreateEnum
CREATE TYPE "tilt_schema"."TypeAbonnementDetail" AS ENUM ('basique', 'premium');

-- CreateEnum
CREATE TYPE "tilt_schema"."StatutPaiement" AS ENUM ('succeeded', 'pending', 'failed');

-- CreateTable
CREATE TABLE "tilt_schema"."utilisateur" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "mot_de_passe" TEXT NOT NULL,
    "nom" TEXT,
    "prenom" TEXT,
    "numero_telephone" TEXT,
    "adresse" TEXT,
    "code_postal" TEXT,
    "ville" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "code_secret" TEXT,
    "type_utilisateur" "tilt_schema"."TypeUtilisateur" NOT NULL,
    "date_creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "utilisateur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."categorie" (
    "id" TEXT NOT NULL,
    "nom_categorie" TEXT NOT NULL,

    CONSTRAINT "categorie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."magasin" (
    "id" TEXT NOT NULL,
    "nom" TEXT,
    "numeros_de_siret" TEXT,
    "numero_telephone" TEXT,
    "email" TEXT,
    "site_web" TEXT,
    "description" TEXT,
    "adresse" TEXT,
    "code_postal" TEXT,
    "ville" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "photo_url" TEXT,
    "horaires_ouverture" TEXT,
    "date_creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_categorie" TEXT,
    "id_utilisateur" TEXT,

    CONSTRAINT "magasin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."programme_fidelite" (
    "id" TEXT NOT NULL,
    "points_par_euro" DOUBLE PRECISION NOT NULL DEFAULT 10.0,
    "palier_points" INTEGER,
    "type_recompense" "tilt_schema"."TypeRecompense" NOT NULL,
    "valeur_recompense" TEXT,
    "description_recompense" TEXT,
    "date_creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_modification" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "programme_fidelite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."achat" (
    "id" TEXT NOT NULL,
    "montant" DOUBLE PRECISION,
    "points_gagnes" DOUBLE PRECISION,
    "date_achat" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_utilisateur" TEXT NOT NULL,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "achat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."recompense" (
    "id" TEXT NOT NULL,
    "points_requis" DOUBLE PRECISION NOT NULL,
    "type_recompense" "tilt_schema"."TypeRecompense" NOT NULL,
    "valeur_recompense" TEXT,
    "description_recompense" TEXT,
    "date_creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "recompense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."point_client" (
    "id" TEXT NOT NULL,
    "solde_points" DOUBLE PRECISION,
    "points_utilises" DOUBLE PRECISION,
    "date_mise_a_jour" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_utilisateur" TEXT NOT NULL,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "point_client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."recompense_utilisee" (
    "id" TEXT NOT NULL,
    "date_utilisation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_utilisateur" TEXT NOT NULL,
    "id_recompense" TEXT NOT NULL,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "recompense_utilisee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."abonnement" (
    "id" TEXT NOT NULL,
    "date_debut" TIMESTAMP(3),
    "date_fin" TIMESTAMP(3),
    "statut" "tilt_schema"."StatutAbonnement" NOT NULL,
    "type_abonnement" "tilt_schema"."TypeAbonnement" NOT NULL,
    "type_abonnement_detail" "tilt_schema"."TypeAbonnementDetail" NOT NULL,
    "montant" DOUBLE PRECISION,
    "stripe_customer_id" TEXT,
    "stripe_subscription_id" TEXT,
    "date_creation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_modification" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_utilisateur" TEXT NOT NULL,

    CONSTRAINT "abonnement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."badge" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "icone_url" TEXT,

    CONSTRAINT "badge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."utilisateurs_badges" (
    "id_utilisateur" TEXT NOT NULL,
    "id_badge" TEXT NOT NULL,
    "date_obtention" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "utilisateurs_badges_pkey" PRIMARY KEY ("id_utilisateur","id_badge")
);

-- CreateTable
CREATE TABLE "tilt_schema"."parrainage" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "points_gagnes" DOUBLE PRECISION,
    "parrain_id" TEXT NOT NULL,
    "filleul_id" TEXT NOT NULL,

    CONSTRAINT "parrainage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."qr_code" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "date_generation" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "actif" BOOLEAN NOT NULL DEFAULT true,
    "id_utilisateur" TEXT NOT NULL,

    CONSTRAINT "qr_code_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."transaction_paiement" (
    "id" TEXT NOT NULL,
    "stripe_payment_intent_id" TEXT,
    "montant" DOUBLE PRECISION,
    "devise" TEXT DEFAULT 'EUR',
    "statut" "tilt_schema"."StatutPaiement" NOT NULL,
    "date_paiement" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_abonnement" TEXT NOT NULL,

    CONSTRAINT "transaction_paiement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."notification" (
    "id" TEXT NOT NULL,
    "titre" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "date_envoi" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lu" BOOLEAN NOT NULL DEFAULT false,
    "id_utilisateur" TEXT NOT NULL,

    CONSTRAINT "notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tilt_schema"."avis" (
    "id" TEXT NOT NULL,
    "note" INTEGER NOT NULL,
    "commentaire" TEXT,
    "date_avis" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "id_utilisateur" TEXT NOT NULL,
    "id_magasin" TEXT NOT NULL,

    CONSTRAINT "avis_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "utilisateur_email_key" ON "tilt_schema"."utilisateur"("email");

-- CreateIndex
CREATE UNIQUE INDEX "magasin_numeros_de_siret_key" ON "tilt_schema"."magasin"("numeros_de_siret");

-- CreateIndex
CREATE UNIQUE INDEX "magasin_email_key" ON "tilt_schema"."magasin"("email");

-- CreateIndex
CREATE UNIQUE INDEX "point_client_id_utilisateur_id_magasin_key" ON "tilt_schema"."point_client"("id_utilisateur", "id_magasin");

-- CreateIndex
CREATE UNIQUE INDEX "qr_code_code_key" ON "tilt_schema"."qr_code"("code");

-- CreateIndex
CREATE UNIQUE INDEX "qr_code_id_utilisateur_actif_key" ON "tilt_schema"."qr_code"("id_utilisateur", "actif");

-- CreateIndex
CREATE INDEX "notification_lu_idx" ON "tilt_schema"."notification"("lu");

-- CreateIndex
CREATE INDEX "avis_note_idx" ON "tilt_schema"."avis"("note");

-- AddForeignKey
ALTER TABLE "tilt_schema"."magasin" ADD CONSTRAINT "magasin_id_categorie_fkey" FOREIGN KEY ("id_categorie") REFERENCES "tilt_schema"."categorie"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."magasin" ADD CONSTRAINT "magasin_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."programme_fidelite" ADD CONSTRAINT "programme_fidelite_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."achat" ADD CONSTRAINT "achat_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."achat" ADD CONSTRAINT "achat_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."recompense" ADD CONSTRAINT "recompense_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."point_client" ADD CONSTRAINT "point_client_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."point_client" ADD CONSTRAINT "point_client_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."recompense_utilisee" ADD CONSTRAINT "recompense_utilisee_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."recompense_utilisee" ADD CONSTRAINT "recompense_utilisee_id_recompense_fkey" FOREIGN KEY ("id_recompense") REFERENCES "tilt_schema"."recompense"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."recompense_utilisee" ADD CONSTRAINT "recompense_utilisee_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."abonnement" ADD CONSTRAINT "abonnement_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."utilisateurs_badges" ADD CONSTRAINT "utilisateurs_badges_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."utilisateurs_badges" ADD CONSTRAINT "utilisateurs_badges_id_badge_fkey" FOREIGN KEY ("id_badge") REFERENCES "tilt_schema"."badge"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."parrainage" ADD CONSTRAINT "parrainage_parrain_id_fkey" FOREIGN KEY ("parrain_id") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."parrainage" ADD CONSTRAINT "parrainage_filleul_id_fkey" FOREIGN KEY ("filleul_id") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."qr_code" ADD CONSTRAINT "qr_code_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."transaction_paiement" ADD CONSTRAINT "transaction_paiement_id_abonnement_fkey" FOREIGN KEY ("id_abonnement") REFERENCES "tilt_schema"."abonnement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."notification" ADD CONSTRAINT "notification_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."avis" ADD CONSTRAINT "avis_id_utilisateur_fkey" FOREIGN KEY ("id_utilisateur") REFERENCES "tilt_schema"."utilisateur"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tilt_schema"."avis" ADD CONSTRAINT "avis_id_magasin_fkey" FOREIGN KEY ("id_magasin") REFERENCES "tilt_schema"."magasin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
