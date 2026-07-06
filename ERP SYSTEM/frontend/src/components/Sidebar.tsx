import React from 'react';
import { useApp } from '../context/AppContext';
import { 
  LayoutDashboard, 
  Settings, 
  MonitorPlay, 
  Package, 
  Users, 
  Wallet, 
  Cpu, 
  Moon, 
  Sun, 
  Building2, 
  LogOut 
} from 'lucide-react';
import { motion } from 'framer-motion';

export const Sidebar: React.FC = () => {
  const { activeTab, setActiveTab, theme, toggleTheme, currentUser } = useApp();

  const menuItems = [
    { id: 'dashboard', label: 'Executive Dashboard', icon: LayoutDashboard },
    { id: 'production', label: 'Production & BOM', icon: Settings },
    { id: 'shopfloor', label: 'Shop Floor Console', icon: MonitorPlay },
    { id: 'inventory', label: 'Inventory & Barcode', icon: Package },
    { id: 'crm', label: 'CRM & Pipelines', icon: Users },
    { id: 'finance', label: 'Finance & HR Ledger', icon: Wallet },
    { id: 'ai-planner', label: 'AI Core Planner', icon: Cpu },
  ];

  return (
    <aside className="w-80 h-screen glass-powder-blue flex flex-col justify-between p-6 fixed left-0 top-0 z-30 transition-colors duration-300">
      <div className="flex flex-col gap-8">
        {/* Brand Header */}
        <div className="flex items-center gap-3 px-2">
          <div className="w-10 h-10 rounded-xl bg-blue-600 flex items-center justify-center text-white font-extrabold text-xl shadow-lg shadow-blue-500/30">
            A
          </div>
          <div>
            <h1 className="font-extrabold text-lg text-slate-900 tracking-tight leading-none">APEX ERP</h1>
            <span className="text-xs font-semibold text-blue-700 uppercase tracking-widest">Enterprise</span>
          </div>
        </div>

        {/* Navigation Items */}
        <nav className="flex flex-col gap-1.5">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`relative flex items-center gap-3.5 px-4 py-3 rounded-xl text-left text-sm font-semibold transition-all duration-200 ${
                  isActive 
                    ? 'text-white' 
                    : 'text-slate-800 hover:bg-sky-100/60'
                }`}
              >
                {isActive && (
                  <motion.div
                    layoutId="activeTabGlow"
                    className="absolute inset-0 bg-blue-600 rounded-xl -z-10 shadow-md shadow-blue-500/20"
                    transition={{ type: 'spring', stiffness: 380, damping: 30 }}
                  />
                )}
                <Icon className={`w-5 h-5 ${isActive ? 'text-white' : 'text-slate-700'}`} />
                {item.label}
              </button>
            );
          })}
        </nav>
      </div>

      {/* Footer Profile & Settings */}
      <div className="flex flex-col gap-4">
        {/* Factory Status Banner */}
        <div className="flex items-center gap-2.5 p-3 rounded-xl bg-sky-200/40 border border-sky-300/30">
          <Building2 className="w-4 h-4 text-blue-700" />
          <div className="text-xs">
            <p className="font-bold text-slate-900">{currentUser.factory}</p>
            <p className="text-[10px] text-slate-600 font-semibold uppercase tracking-wider">Active Plant</p>
          </div>
        </div>

        {/* Theme Toggle */}
        <button 
          onClick={toggleTheme}
          className="flex items-center justify-between px-4 py-3 rounded-xl text-sm font-semibold text-slate-800 hover:bg-sky-100/60 transition-colors"
        >
          <span className="flex items-center gap-3">
            {theme === 'dark' ? <Sun className="w-5 h-5 text-amber-600" /> : <Moon className="w-5 h-5 text-blue-700" />}
            {theme === 'dark' ? 'Light Mode' : 'Dark Mode'}
          </span>
          <div className="w-8 h-4 rounded-full bg-slate-300/70 relative p-0.5 transition-colors">
            <div className={`w-3 h-3 rounded-full bg-white transition-all ${theme === 'dark' ? 'translate-x-4' : 'translate-x-0'}`} />
          </div>
        </button>

        {/* User Card */}
        <div className="flex items-center gap-3 pt-4 border-t border-sky-200/60">
          <img 
            src={currentUser.avatar} 
            alt="User profile" 
            className="w-10 h-10 rounded-full object-cover ring-2 ring-blue-600/20"
          />
          <div className="flex-1 min-w-0">
            <h4 className="text-sm font-bold text-slate-900 truncate">{currentUser.name}</h4>
            <span className="text-[11px] font-semibold bg-blue-100 text-blue-700 px-1.5 py-0.5 rounded-md">
              {currentUser.role}
            </span>
          </div>
          <button className="text-slate-600 hover:text-rose-600 transition-colors">
            <LogOut className="w-5 h-5" />
          </button>
        </div>
      </div>
    </aside>
  );
};
