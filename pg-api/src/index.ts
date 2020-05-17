import { Pool } from 'pg';
import express from 'express';
import logger from 'fluent-logger';

const app = express();

logger.configure('fluentd.api', {
  host: String(process.env.FLUENTD_HOST) || '127.0.0.1',
  port: 24224,
  timeout: 5.0,
  reconnectInterval: 1000 * 60 * 5, // 5 minutes
});

const apiPort = Number(process.env.API_PORT || 40000);

const pqPool = new Pool({
  user: String(process.env.POSTGRES_USER || 'postgres'),
  host: String(process.env.POSTGRES_HOST || '127.0.0.1'),
  database: String(process.env.POSTGRES_DB || 'postgres_db'),
  password: String(process.env.POSTGRES_PASSWORD || 'postgres'),
  port: Number(process.env.POSTGRES_PORT || 5432),
  max: 10,
});

const fluentLogger = (eventName: string, data: object): void => {
  logger.emit(eventName, data);
};

interface QueryOpts {
  pool: any;
  sql: string;
  params?: Array<any>; // optional
}

const query = (opts: QueryOpts): Promise<any> => new Promise((resolve, reject) => {
  try {
    const { pool, sql, params } = opts;
    pool.query(sql, params, (err: any, data: any) => {
      if (err) {
        fluentLogger('query error', { identifier: sql, params });
        return reject(err);
      }

      fluentLogger('query success', { identifier: sql, params });
      return resolve(data && data.rows);
    });
  } catch (exception) {
    reject(exception);
  }
});

app.get('/api/v1/users', async (req, res) => {
  fluentLogger('route', { identifier: 'users', params: {} });

  try {
    const sql = 'SELECT * FROM users';
    let data: Array<any>;

    try {
      data = await query({ pool: pqPool, sql });
    } catch (exception0) {
      fluentLogger('route error', { identifier: 'users', params: {}, error: exception0 });
      return res.status(500).json({ status: 'error', message: 'internal_error' });
    }

    if (!data || !data.length) {
      fluentLogger('route error', { identifier: 'users', params: {}, error: 'not_found' });
      return res.status(404).json({ status: 'error', message: 'not_found' });
    }

    return res.status(200).json({ status: 'success', data });
  } catch (exception1) {
    fluentLogger('route error', { identifier: 'users', params: {}, error: exception1 });
    return res.status(500).json({ status: 'error', message: 'internal_error' });
  }
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
    let data: Array<any>;

    try {
      data = await query({ pool: pqPool, sql, params: [ id ] });
    } catch (exception0) {
      fluentLogger('route error', { identifier: 'users', params: { id }, error: exception0 });
      return res.status(500).json({ status: 'error', message: 'internal_error' });
    }

    if (!data || !data.length) {
      fluentLogger('route error', { identifier: 'users', params: { id }, error: 'not_found' });
      return res.status(404).json({ status: 'error', message: 'not_found' });
    }

    return res.status(200).json({ status: 'success', data });
  } catch (exception1) {
    fluentLogger('route error', { identifier: 'users', params: { id }, error: exception1 });
    return res.status(500).json({ status: 'error', message: 'internal_error' });
  }
});

app.get('/api/v1/healthcheck', async (req, res) => {
  fluentLogger('route', { identifier: 'healthcheck', params: {} });

  const sql = 'SELECT 1';

  try {
    await query({ pool: pqPool, sql });
  } catch (exception0) {
    fluentLogger('route error', { identifier: 'healthcheck', params: {}, error: exception0 });
    return res.status(500).json({ status: 'error', message: 'internal_error' });
  }

  return res.status(200).json({ status: 'success' });
});

/* eslint-disable no-console */
app.listen(apiPort, (): void => console.info(`Listening on port ${apiPort}`));
