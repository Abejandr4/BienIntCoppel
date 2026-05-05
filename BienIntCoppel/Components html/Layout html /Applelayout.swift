//
//  Applelayout.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { Outlet } from "react-router-dom";
import BottomNav from "./BottomNav";

export default function AppLayout() {
  return (
    <div className="min-h-screen bg-background font-body">
      <div className="max-w-lg mx-auto pb-24">
        <Outlet />
      </div>
      <BottomNav />
    </div>
  );
}
