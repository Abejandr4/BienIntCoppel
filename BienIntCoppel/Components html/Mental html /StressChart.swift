//
//  StressChart.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { TrendingUp } from "lucide-react";
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

const stressData = [
  { hour: "8:00", stress: 25 },
  { hour: "9:00", stress: 40 },
  { hour: "10:00", stress: 55 },
  { hour: "11:00", stress: 72 },
  { hour: "12:00", stress: 60 },
  { hour: "13:00", stress: 35 },
  { hour: "14:00", stress: 50 },
  { hour: "15:00", stress: 68 },
  { hour: "16:00", stress: 78 },
  { hour: "17:00", stress: 45 },
  { hour: "18:00", stress: 30 },
];

export default function StressChart() {
  return (
    <section className="px-5 mt-4" aria-labelledby="stress-chart-title">
      <div className="bg-card rounded-2xl border border-border shadow-sm p-5">
        <div className="flex items-center gap-2 mb-1">
          <TrendingUp className="w-4 h-4 text-accent" aria-hidden="true" />
          <h3 id="stress-chart-title" className="text-base font-heading font-bold text-foreground">
            Análisis de Picos de Estrés
          </h3>
        </div>
        <p className="text-xs font-body text-muted-foreground mb-4">
          Basado en tu horario laboral
        </p>

        <div className="h-44">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={stressData}>
              <defs>
                <linearGradient id="stressGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stopColor="#f97316" stopOpacity={0.3} />
                  <stop offset="100%" stopColor="#34d399" stopOpacity={0.05} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(30,15%,92%)" />
              <XAxis
                dataKey="hour"
                tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }}
                axisLine={false}
                tickLine={false}
                domain={[0, 100]}
                label={{ value: "Estrés", angle: -90, position: "insideLeft", fontSize: 10, fill: "hsl(220,10%,46%)" }}
              />
              <Tooltip
                contentStyle={{
                  borderRadius: "12px",
                  border: "none",
                  boxShadow: "0 4px 12px rgba(0,0,0,0.08)",
                  fontSize: "12px",
                }}
                formatter={(value) => [`${value}%`, "Nivel de estrés"]}
              />
              <Area
                type="monotone"
                dataKey="stress"
                stroke="#f97316"
                strokeWidth={2.5}
                fill="url(#stressGradient)"
                dot={{ r: 3, fill: "#f97316", strokeWidth: 0 }}
                activeDot={{ r: 5, fill: "#f97316", stroke: "#fff", strokeWidth: 2 }}
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Peak indicators */}
        <div className="flex gap-2 mt-3">
          <div className="flex-1 bg-orange-50 rounded-xl px-3 py-2 text-center">
            <p className="text-[10px] font-body text-muted-foreground">Pico máximo</p>
            <p className="text-sm font-heading font-bold text-orange-500">16:00h</p>
          </div>
          <div className="flex-1 bg-emerald-50 rounded-xl px-3 py-2 text-center">
            <p className="text-[10px] font-body text-muted-foreground">Más relajado</p>
            <p className="text-sm font-heading font-bold text-emerald-500">8:00h</p>
          </div>
          <div className="flex-1 bg-amber-50 rounded-xl px-3 py-2 text-center">
            <p className="text-[10px] font-body text-muted-foreground">Promedio</p>
            <p className="text-sm font-heading font-bold text-amber-500">50%</p>
          </div>
        </div>
      </div>
    </section>
  );
}
