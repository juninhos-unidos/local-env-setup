db = db.getSiblingDB(process.env.INSURANCE_DB_NAME);

db.createUser({
    user: process.env.INSURANCE_DB_USER,
    pwd: process.env.INSURANCE_DB_PASS,
    roles: [{role: "readWrite", db: process.env.INSURANCE_DB_NAME}]
});