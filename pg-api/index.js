const { Pool } = require('pg');
const express = require('express');
const logger = require('fluent-logger');

const app = express();

logger.configure('fluentd.api', {
  host: process.env.FLUENTD_HOST,
  port: 24224,
  timeout: 5.0,
  reconnectInterval: 1000 * 60 * 5, // 5 minutes
});

const apiPort = process.env.API_PORT;

const pqPool = new Pool({
  user: process.env.POSTGRES_USER,
  host: process.env.POSTGRES_HOST,
  database: process.env.POSTGRES_DB,
  password: process.env.POSTGRES_PASSWORD,
  port: process.env.POSTGRES_PORT,
  max: 10,
});

const fluentLogger = (eventName, data) => {
  logger.emit(eventName, data);
};

const query = (pool, sql, ...params) => new Promise((resolve, reject) => {
  pool.query(sql, ...params, (err, data) => {
    if (err) {
      fluentLogger('query error', { identifier: sql, params: { ...params } });
      return reject(err);
    }

    fluentLogger('query success', { identifier: sql, params: { ...params } });
    return resolve(data.rows);
  });
});

app.get('/api/v1/users/:id', async (req, res) => {
  const { id } = req.params;
  fluentLogger('route', { identifier: 'users', params: { id } });

  if (!id || id.toString().replace(/[\d]+/g, '').length > 0) {
    fluentLogger('route error', { identifier: 'users', params: { id }, error: 'invalid_params' });

    return res.status(400).json({ status: 'error', message: 'invalid_params' });
  }

  try {
    const sql = 'SELECT * FROM users WHERE id = $1';
    const data = await query(pqPool, sql, [id]);

    if (!data || !data.length) {
      fluentLogger('route error', { identifier: 'users', params: { id }, error: 'not_found' });

      return res.status(404).json({ status: 'error', message: 'not_found' });
    }

    return res.status(200).json({ status: 'success', data });
  } catch (error) {
    fluentLogger('route error', { identifier: 'users', params: { id }, error });

    return res.status(500).json({ status: 'error', message: 'internal_error' });
  }
});

// TODO: improve healthcheck
app.get('/api/v1/healthcheck', async (req, res) => {
  return res.status(200).json({ status: 'success' });
});

app.listen(apiPort, () => console.info(`Listening on port ${apiPort}`));
