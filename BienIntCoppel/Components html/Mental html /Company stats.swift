//
//  Company stats.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useState } from "react";
import { X, BarChart3, Info } from "lucide-react";
import { PieChart, Pie, Cell, ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip } from "recharts";
import { motion, AnimatePresence } from "framer-motion";

const pieData = [
  { name: "Estrés Crónico", value: 35, color: "#f97316" },
  { name: "Estrés Moderado", value: 40, color: "#facc15" },
  { name: "Bajo Estrés", value: 25, color: "#34d399" },
];

const barData = [
  { name: "Estrés Crónico", value: 35 },
  { name: "Ansiedad", value: 28 },
  { name: "Burnout", value: 18 },
  { name: "Bienestar", value: 42 },
];

export default function CompanyStats() {
  const [visible, setVisible] = useState(true);

  return (
    <AnimatePresence>
      {visible && (
        <motion.section
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: "auto" }}
          exit={{ opacity: 0, height: 0 }}
          className="px-5 mt-4"
          aria-labelledby="stats-title"
        >
          <div className="bg-card rounded-2xl border border-border shadow-sm p-5 relative">
            <button
              onClick={() => setVisible(false)}
              className="absolute top-3 right-3 w-7 h-7 rounded-full bg-muted flex items-center justify-center hover:bg-muted/80 transition-colors"
              aria-label="Cerrar estadísticas"
            >
              <X className="w-4 h-4 text-muted-foreground" />
            </button>

            <div className="flex items-center gap-2 mb-4">
              <BarChart3 className="w-4 h-4 text-primary" aria-hidden="true" />
              <h3 id="stats-title" className="text-base font-heading font-bold text-foreground">
                Estadísticas de la Empresa
              </h3>
            </div>

            <div className="grid grid-cols-2 gap-4">
              {/* Pie Chart */}
              <div>
                <p className="text-xs font-body font-medium text-muted-foreground mb-2 text-center">Niveles de Estrés</p>
                <div className="h-32">
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie
                        data={pieData}
                        cx="50%"
                        cy="50%"
                        innerRadius={25}
                        outerRadius={50}
                        dataKey="value"
                        stroke="none"
                      >
                        {pieData.map((entry, i) => (
                          <Cell key={i} fill={entry.color} />
                        ))}
                      </Pie>
                      <Tooltip
                        formatter={(value) => [`${value}%`, ""]}
                        contentStyle={{ borderRadius: "12px", border: "none", boxShadow: "0 4px 12px rgba(0,0,0,0.08)", fontSize: "12px" }}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                </div>
                <div className="space-y-1 mt-2">
                  {pieData.map(d => (
                    <div key={d.name} className="flex items-center gap-1.5 text-[10px] font-body text-muted-foreground">
                      <span className="w-2 h-2 rounded-full" style={{ backgroundColor: d.color }} />
                      {d.name}: {d.value}%
                    </div>
                  ))}
                </div>
              </div>

              {/* Bar Chart */}
              <div>
                <p className="text-xs font-body font-medium text-muted-foreground mb-2 text-center">Indicadores Clave</p>
                <div className="h-32">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={barData} barCategoryGap="20%">
                      <CartesianGrid strokeDasharray="3 3" stroke="hsl(30,15%,90%)" />
                      <XAxis dataKey="name" tick={false} axisLine={false} />
                      <YAxis hide />
                      <Tooltip
                        formatter={(value) => [`${value}%`, ""]}
                        contentStyle={{ borderRadius: "12px", border: "none", boxShadow: "0 4px 12px rgba(0,0,0,0.08)", fontSize: "12px" }}
                      />
                      <Bar dataKey="value" radius={[6, 6, 0, 0]} fill="url(#barGradient)" />
                      <defs>
                        <linearGradient id="barGradient" x1="0" y1="0" x2="0" y2="1">
                          <stop offset="0%" stopColor="#f97316" />
                          <stop offset="100%" stopColor="#34d399" />
                        </linearGradient>
                      </defs>
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </div>
            </div>

            <div className="flex items-center gap-1.5 mt-4 bg-muted/50 rounded-lg px-3 py-2">
              <Info className="w-3 h-3 text-muted-foreground flex-shrink-0" aria-hidden="true" />
              <p className="text-[10px] font-body text-muted-foreground">Datos ilustrativos y anónimos de la empresa</p>
            </div>
          </div>
        </motion.section>
      )}
    </AnimatePresence>
  );
}
