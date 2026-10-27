-- One-time migration for the client-product checklist feature.
-- Adds clientId so client_product can link a product to a client.
-- Note: the existing `userId` column in client_product looks like a copy-paste
-- leftover from the user_product table; this feature keys off clientId instead.
ALTER TABLE `client_product`
    ADD COLUMN `clientId` int(11) NOT NULL DEFAULT 0 AFTER `id`,
    ADD KEY `clientId` (`clientId`);
