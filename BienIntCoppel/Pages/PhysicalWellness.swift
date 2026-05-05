//
//  PhysicalWellness.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useState } from "react";
import { Link } from "react-router-dom";
import { ArrowLeft, Activity, Clock, MapPin, Footprints, Dumbbell, Scale, X, ChevronRight, Phone, Heart } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { Button } from "@/components/ui/button";

const activityStats = [
  { label: "Tiempo", value: "0 Min", icon: Clock },
  { label: "Distancia", value: "0.00 Km", icon: MapPin },
  { label: "Pasos", value: "1,053", icon: Footprints },
];

const trainingStats = [
  { label: "Cantidad", value: "13 Veces" },
  { label: "Tiempo", value: "635 Min" },
  { label: "Distancia", value: "99.64 Km" },
  { label: "Pasos", value: "0" },
];

const quickAccess = [
  {
    title: "Tu actividad",
    desc: "Visualiza tu historial de entrenamientos y objetivos cumplidos.",
    icon: Dumbbell,
    color: "text-orange-500",
    bg: "bg-orange-100",
  },
  {
    title: "Peso y altura",
    desc: "Registra tu peso y altura para el cálculo de calorías.",
    icon: Scale,
    color: "text-emerald-500",
    bg: "bg-emerald-100",
  },
  {
    title: "Coppel Contigo",
    desc: "Orientación telefónica especializada, ocupas ambulancia o algún apoyo económico.",
    icon: Heart,
    color: "text-orange-500",
    bg: "bg-orange-100",
  },
  {
    title: "Llamar a Coppel Contigo",
    desc: "Orientación telefónica especializada, ocupas ambulancia o algún apoyo económico.",
    icon: Phone,
    color: "text-emerald-600",
    bg: "bg-emerald-100",
  },
];

const challenges = [
  {
    title: "Entrenamientos 2026",
    desc: "Todos los entrenamientos 2026",
    emoji: "🏃",
  },
  {
    title: "Actívate 10,000 pasos",
    desc: "Realizar 10,000 pasos al día durante un mes.",
    emoji: "🚶",
  },
  {
    title: "Reto de Actividad Física 2026",
    desc: "¡Actívate y súmate al reto!",
    emoji: "💪",
  },
  {
    title: "Camina tu maratón 2026",
    desc: "Camina, corre o usa la caminadora. Recorre de manera individual 42,195 metros.",
    emoji: "🏅",
  },
  {
    title: "Reto Actívate en Familia 2026",
    desc: "El colaborador deberán realizar una rutina de ejercicios: 10 minutos de calentamiento, 10 minutos aeróbico y 10 minutos de fuerza.",
    emoji: "👨‍👩‍👧",
  },
];

export default function PhysicalWellness() {
  const [showBanner, setShowBanner] = useState(true);

  return (
    <div className="min-h-screen bg-background relative">
      {/* Header */}
      <div className="relative overflow-hidden rounded-b-3xl">
        <div className="absolute inset-0 bg-gradient-to-br from-orange-400 via-amber-300 to-emerald-300 opacity-90" />
        <div className="relative px-5 pt-12 pb-6">
          <div className="flex items-center gap-3">
            <Link
              to="/"
              className="w-9 h-9 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center hover:bg-white/30 transition-colors"
              aria-label="Volver al inicio"
            >
              <ArrowLeft className="w-5 h-5 text-white" />
            </Link>
            <div className="flex items-center gap-2">
              <Activity className="w-5 h-5 text-white" aria-hidden="true" />
              <div>
                <h1 className="text-xl font-heading font-bold text-white">Bienestar Físico</h1>
                <p className="text-xs font-body text-white/80">Tu actividad y salud</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="px-5 pb-8 space-y-6 mt-5">

        {/* Tu actividad hoy */}
        <section aria-labelledby="activity-today">
          <h2 id="activity-today" className="text-lg font-heading font-bold text-foreground mb-4">
            Tu actividad hoy
          </h2>
          <div className="bg-card rounded-2xl border border-border shadow-sm p-5">
            <div className="flex justify-around">
              {activityStats.map(({ label, value, icon: Icon }) => (
                <div key={label} className="flex flex-col items-center gap-2">
                  <div className="w-12 h-12 rounded-full border-2 border-orange-300 bg-orange-50 flex items-center justify-center">
                    <Icon className="w-5 h-5 text-orange-400" aria-hidden="true" />
                  </div>
                  <p className="text-base font-heading font-bold text-foreground">{value}</p>
                  <p className="text-xs font-body text-muted-foreground">{label}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Tus Entrenamientos */}
        <section aria-labelledby="trainings-title">
          <h2 id="trainings-title" className="text-lg font-heading font-bold text-foreground mb-4">
            Tus Entrenamientos <span className="text-primary">(13)</span>
          </h2>
          <div className="bg-card rounded-2xl border border-border shadow-sm p-5">
            <div className="grid grid-cols-4 gap-2">
              {trainingStats.map(({ label, value }) => (
                <div key={label} className="flex flex-col items-center text-center">
                  <p className="text-sm font-heading font-bold text-foreground">{value}</p>
                  <p className="text-[10px] font-body text-muted-foreground mt-0.5">{label}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Plan de Alimentación */}
        <section aria-labelledby="nutrition-title">
          <h2 id="nutrition-title" className="text-lg font-heading font-bold text-foreground mb-2">
            Plan de Alimentación
          </h2>
          <div className="bg-card rounded-2xl border border-border shadow-sm p-5 space-y-4">
            <p className="text-sm font-body text-muted-foreground leading-relaxed">
              Te invitamos a complementar tu atención, agendando una Teleconsulta Nutricional a través de{" "}
              <a href="https://www.coppelcontigo.com" target="_blank" rel="noopener noreferrer" className="text-emerald-600 underline font-medium">
                www.coppelcontigo.com
              </a>{" "}
              con alguno de los nutriólogos expertos que tenemos disponibles para ti o llamando a la línea Coppel Contigo{" "}
              <a href="tel:8000200450" className="text-emerald-600 underline font-medium">
                800 020 4050
              </a>{" "}
              &gt; Plan Salud &gt; 2 &gt; Opción 4.
            </p>
            <p className="text-sm font-body text-foreground font-medium">Solicita tu plan personalizado.</p>
            <Button className="w-full rounded-xl bg-emerald-500 hover:bg-emerald-600 text-white font-heading font-semibold border-0 h-12 text-base">
              Solicitar plan
            </Button>
          </div>
        </section>

        {/* Accesos rápidos */}
        <section aria-labelledby="quick-access-title">
          <h2 id="quick-access-title" className="text-lg font-heading font-bold text-foreground mb-3">
            Accesos rápidos
          </h2>
          <div className="space-y-3">
            {quickAccess.map(({ title, desc, icon: Icon, color, bg }) => (
              <button
                key={title}
                className="w-full bg-card rounded-2xl border border-border shadow-sm p-4 flex items-center gap-4 hover:shadow-md transition-all text-left"
                aria-label={title}
              >
                <div className={`w-12 h-12 rounded-xl ${bg} flex items-center justify-center flex-shrink-0`}>
                  <Icon className={`w-6 h-6 ${color}`} aria-hidden="true" />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-heading font-bold text-foreground">{title}</p>
                  <p className="text-xs font-body text-muted-foreground mt-0.5 leading-relaxed">{desc}</p>
                </div>
                <ChevronRight className="w-4 h-4 text-muted-foreground flex-shrink-0" />
              </button>
            ))}
          </div>
        </section>

        {/* Retos */}
        <section aria-labelledby="challenges-title">
          <h2 id="challenges-title" className="text-lg font-heading font-bold text-foreground mb-3">
            Retos
          </h2>
          <div className="space-y-3">
            {challenges.map(({ title, desc, emoji }) => (
              <button
                key={title}
                className="w-full bg-card rounded-2xl border border-border shadow-sm p-4 flex items-center gap-4 hover:shadow-md transition-all text-left"
                aria-label={title}
              >
                <div className="w-12 h-12 rounded-xl bg-orange-50 flex items-center justify-center flex-shrink-0 text-2xl">
                  {emoji}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-heading font-bold text-foreground">{title}</p>
                  <p className="text-xs font-body text-muted-foreground mt-0.5 leading-relaxed">{desc}</p>
                </div>
                <ChevronRight className="w-4 h-4 text-muted-foreground flex-shrink-0" />
              </button>
            ))}
          </div>
        </section>

        {/* Échale los Kilos Banner Card */}
        <section aria-label="Programa Échale los Kilos">
          <div className="relative overflow-hidden rounded-2xl h-44">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-900 via-blue-800 to-blue-700" />
            <div className="absolute right-0 top-0 bottom-0 w-1/2 bg-gradient-to-l from-emerald-400/30 to-transparent" />
            {/* Dots pattern */}
            <div className="absolute right-4 top-2 grid grid-cols-6 gap-1.5 opacity-60">
              {Array.from({ length: 30 }).map((_, i) => (
                <div
                  key={i}
                  className="w-2 h-2 rounded-full"
                  style={{ backgroundColor: i % 3 === 0 ? "#34d399" : i % 3 === 1 ? "#60a5fa" : "#a78bfa" }}
                />
              ))}
            </div>
            <div className="relative p-5 flex flex-col justify-center h-full">
              <p className="text-white/80 text-[10px] font-body font-medium tracking-widest uppercase mb-1">Échale los Kilos ••• Coppel</p>
              <p className="text-white text-xl font-heading font-black leading-tight">
                ¡El poder<br />
                <span className="text-yellow-400">está en ti!</span>
              </p>
              <p className="text-white/80 text-xs font-body mt-2 max-w-[55%] leading-relaxed">
                Inscríbete hoy al programa <em className="font-bold not-italic">Échale los Kilos</em> y da el primer paso.
              </p>
              <button className="mt-3 self-start bg-blue-900 border border-blue-400/40 text-white text-xs font-heading font-bold px-4 py-1.5 rounded-full hover:bg-blue-800 transition-colors">
                ¿Te atreves?
              </button>
            </div>
          </div>
        </section>

      </div>

      {/* Pop-up Banner "¿Ya te inscribiste?" */}
      <AnimatePresence>
        {showBanner && (
          <motion.div
            initial={{ y: 120, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: 120, opacity: 0 }}
            transition={{ type: "spring", damping: 22, stiffness: 280 }}
            className="fixed bottom-20 left-0 right-0 z-50 px-4"
          >
            <div className="max-w-lg mx-auto relative overflow-hidden rounded-2xl shadow-2xl">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-900 via-blue-800 to-blue-700" />
              <div className="absolute right-0 top-0 bottom-0 w-2/5 overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=200&h=200&fit=crop"
                  alt=""
                  className="h-full w-full object-cover opacity-60 mix-blend-luminosity"
                />
                {/* dots overlay */}
                <div className="absolute inset-0 grid grid-cols-5 gap-1 p-2 opacity-70">
                  {Array.from({ length: 25 }).map((_, i) => (
                    <div key={i} className="w-1.5 h-1.5 rounded-full"
                      style={{ backgroundColor: i % 3 === 0 ? "#34d399" : i % 3 === 1 ? "#60a5fa" : "#a78bfa" }} />
                  ))}
                </div>
              </div>
              <div className="relative p-4 pr-[40%]">
                <p className="text-white/70 text-[9px] font-body font-semibold tracking-widest uppercase mb-0.5">Échale los Kilos ••• Coppel</p>
                <p className="text-white text-base font-heading font-black leading-tight">
                  ¿Ya te inscribiste a{" "}
                  <span className="text-yellow-400">Échale los Kilos?</span>
                </p>
                <p className="text-white/80 text-[11px] font-body mt-1.5 leading-relaxed">
                  Avanza hacia tu bienestar con asesoría de nutriólogos especializados. Participa de forma presencial o virtual.
                </p>
                <button className="mt-2.5 bg-yellow-400 text-blue-900 text-xs font-heading font-black px-4 py-1.5 rounded-full hover:bg-yellow-300 transition-colors">
                  ¡Inscríbete ahora!
                </button>
              </div>
              <button
                onClick={() => setShowBanner(false)}
                className="absolute top-2.5 right-2.5 w-6 h-6 rounded-full bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors z-10"
                aria-label="Cerrar aviso"
              >
                <X className="w-3.5 h-3.5 text-white" />
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
