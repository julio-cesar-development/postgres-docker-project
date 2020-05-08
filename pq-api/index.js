const { Pool } = require('pg');
const express = require('express');

const apiPort = process.env.API_PORT;

const app = express();

const pool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT,
  max: 10,
})

const query = (pool, sql, ...params) => new Promise((resolve, reject) => {
  pool.query(sql, ...params, (err, data) => {
    if (err) {
      console.error(err.stack);
      return reject(err);
    }

    console.info('data', data.rows);
    return resolve(data.rows);
  });
});

app.get('/api/v1/index/:id', async (req, res) => {
  const { id } = req.params;
  console.info(`route /index/${id}`);

  if (!id || id.toString().replace(/[\d]+/g, '').length > 0) {
    res.status(400).json({ status: 'error', message: 'invalid_params' });
  }

  try {
    const sql = 'SELECT * FROM users WHERE id = $1';
    const data = await query(pool, sql, [id]);

    if (!data || !data.length) {
      res.status(404).json({ status: 'error', message: 'not_found' });
    }

    res.status(200).json({ status: 'success', data });
  } catch(exception) {
    console.error(exception);

    res.status(500).json({ status: 'error', message: 'internal_error' });
  }
});

app.listen(apiPort, () => console.info(`Listening on port ${apiPort}`));
