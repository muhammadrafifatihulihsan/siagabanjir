/**
 * Router Terpadu Modul Pesan & Inbox SiagaBanjir
 * Menggabungkan endpoint admin dan kotak masuk warga menjadi satu plugin Fastify.
 */
import type { FastifyInstance } from 'fastify';
import type { AuthDependencies } from '../auth/signup.js';
import { registerAdminMessages } from './messages/admin.js';
import { registerCitizenMessages } from './messages/citizen.js';

export function registerMessages(
  app: FastifyInstance,
  deps: AuthDependencies,
): void {
  registerAdminMessages(app, deps);
  registerCitizenMessages(app, deps);
}
