import React from 'react';
import { useApp, AppProvider } from './context/AppContext';
import { Sidebar } from './components/Sidebar';
import { Dashboard } from './pages/Dashboard';
import { Production } from './pages/Production';
import { ShopFloor } from './pages/ShopFloor';
import { Inventory } from './pages/Inventory';
import { CRM } from './pages/CRM';
import { FinanceHR } from './pages/FinanceHR';
import { AIPlanner } from './pages/AIPlanner';
import { motion, AnimatePresence } from 'framer-motion';

const MainContent: React.FC = () => {
  const { activeTab } = useApp();

  const renderActivePage = () => {
    switch (activeTab) {
      case 'dashboard':
        return <Dashboard />;
      case 'production':
        return <Production />;
      case 'shopfloor':
        return <ShopFloor />;
      case 'inventory':
        return <Inventory />;
      case 'crm':
        return <CRM />;
      case 'finance':
        return <FinanceHR />;
      case 'ai-planner':
        return <AIPlanner />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <div className="min-h-screen pl-80 bg-slate-50 dark:bg-slate-950 text-slate-800 dark:text-slate-100 transition-colors duration-300">
      <main className="max-w-7xl mx-auto px-8 py-10">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -15 }}
            transition={{ duration: 0.25, ease: 'easeOut' }}
          >
            {renderActivePage()}
          </motion.div>
        </AnimatePresence>
      </main>
    </div>
  );
};

function App() {
  return (
    <AppProvider>
      <div className="flex">
        <Sidebar />
        <div className="flex-1">
          <MainContent />
        </div>
      </div>
    </AppProvider>
  );
}

export default App;
