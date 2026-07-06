import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { 
  Users, 
  DollarSign, 
  Mail, 
  Phone, 
  Briefcase, 
  Plus, 
  Search, 
  TrendingUp, 
  ArrowRight
} from 'lucide-react';

interface Lead {
  id: string;
  name: string;
  company: string;
  email: string;
  phone: string;
  value: number;
  status: 'Lead' | 'Contacted' | 'Opportunity' | 'Quotation' | 'Customer';
  lastFollowUp: string;
}

export const CRM: React.FC = () => {
  const [leads, setLeads] = useState<Lead[]>([
    { id: '1', name: 'John Smith', company: 'AeroTech Solutions', email: 'jsmith@aerotech.com', phone: '+1-555-0199', value: 120000, status: 'Opportunity', lastFollowUp: '2026-07-04' },
    { id: '2', name: 'Sarah Jenkins', company: 'NextGen Manufacturing', email: 'sjenkins@nextgen-mfg.com', phone: '+1-555-0182', value: 450000, status: 'Quotation', lastFollowUp: '2026-07-05' },
    { id: '3', name: 'Michael Chang', company: 'Zenith Logistics', email: 'mchang@zenith.com', phone: '+1-555-0112', value: 85000, status: 'Contacted', lastFollowUp: '2026-07-02' },
    { id: '4', name: 'Elena Rostova', company: 'Vostok Space Corp', email: 'erostova@vostok.ru', phone: '+7-915-0992', value: 920000, status: 'Lead', lastFollowUp: '2026-06-30' },
    { id: '5', name: 'Arjun Nair', company: 'Bharat Electricals Ltd', email: 'arjun@bharatele.in', phone: '+91-9840-0291', value: 1500000, status: 'Customer', lastFollowUp: '2026-07-06' }
  ]);

  const [searchQuery, setSearchQuery] = useState('');
  const [isAddingLead, setIsAddingLead] = useState(false);
  const [newLeadName, setNewLeadName] = useState('');
  const [newLeadCompany, setNewLeadCompany] = useState('');
  const [newLeadValue, setNewLeadValue] = useState(50000);

  const columns: { id: Lead['status']; label: string; color: string }[] = [
    { id: 'Lead', label: 'Lead Ingest', color: 'bg-slate-100 dark:bg-slate-800 border-slate-200' },
    { id: 'Contacted', label: 'Contact Established', color: 'bg-indigo-50/50 dark:bg-indigo-950/20 border-indigo-200/40' },
    { id: 'Opportunity', label: 'Tech Qualified', color: 'bg-blue-50/50 dark:bg-blue-950/20 border-blue-200/40' },
    { id: 'Quotation', label: 'Quotation Sent', color: 'bg-amber-50/50 dark:bg-amber-950/20 border-amber-200/40' },
    { id: 'Customer', label: 'Closed Deal', color: 'bg-emerald-50/50 dark:bg-emerald-950/20 border-emerald-200/40' }
  ];

  const handleAdvanceStatus = (leadId: string) => {
    const statusOrder: Lead['status'][] = ['Lead', 'Contacted', 'Opportunity', 'Quotation', 'Customer'];
    setLeads(prev => prev.map(lead => {
      if (lead.id === leadId) {
        const currentIndex = statusOrder.indexOf(lead.status);
        const nextIndex = Math.min(currentIndex + 1, statusOrder.length - 1);
        return { ...lead, status: statusOrder[nextIndex], lastFollowUp: new Date().toISOString().split('T')[0] };
      }
      return lead;
    }));
  };

  const addLead = () => {
    if (!newLeadName || !newLeadCompany) return;
    const newLead: Lead = {
      id: String(leads.length + 1),
      name: newLeadName,
      company: newLeadCompany,
      email: `${newLeadName.toLowerCase().replace(' ', '')}@${newLeadCompany.toLowerCase().replace(' ', '')}.com`,
      phone: '+1-555-0900',
      value: newLeadValue,
      status: 'Lead',
      lastFollowUp: new Date().toISOString().split('T')[0]
    };
    setLeads(prev => [newLead, ...prev]);
    setIsAddingLead(false);
    setNewLeadName('');
    setNewLeadCompany('');
  };

  const filteredLeads = leads.filter(l => 
    l.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    l.company.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-extrabold text-slate-800 dark:text-white tracking-tight">Customer Relationship Management (CRM)</h2>
          <p className="text-slate-500 dark:text-slate-400 mt-1">Nurture manufacturing pipelines, dispatch quotes, and track customer lifecycles.</p>
        </div>

        <button 
          onClick={() => setIsAddingLead(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold px-4 py-2.5 rounded-xl shadow-md shadow-blue-500/20 transition-all flex items-center gap-2"
        >
          <Plus className="w-4 h-4" />
          Ingest Lead
        </button>
      </div>

      {/* CRM Stats Banner */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
          <div className="p-3 bg-blue-50 dark:bg-blue-900/20 text-blue-600 dark:text-blue-400 rounded-xl">
            <DollarSign className="w-6 h-6" />
          </div>
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Pipeline Estimated Value</span>
            <span className="text-xl font-black text-slate-800 dark:text-white">₹31,40,000</span>
          </div>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
          <div className="p-3 bg-indigo-50 dark:bg-indigo-900/20 text-indigo-600 dark:text-indigo-400 rounded-xl">
            <Users className="w-6 h-6" />
          </div>
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Active Deals in Play</span>
            <span className="text-xl font-black text-slate-800 dark:text-white">{leads.length} Opportunities</span>
          </div>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/60 card-shadow p-6 rounded-2xl flex items-center gap-4">
          <div className="p-3 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 rounded-xl">
            <TrendingUp className="w-6 h-6" />
          </div>
          <div>
            <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block">Win Conversion Rate</span>
            <span className="text-xl font-black text-slate-800 dark:text-white">68.2%</span>
          </div>
        </div>
      </div>

      {/* Kanban Board Pipelines */}
      <div className="space-y-4">
        {/* Search pipeline */}
        <div className="relative">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input 
            type="text" 
            placeholder="Search leads by client name or company..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 pl-9 pr-4 py-2.5 rounded-xl text-xs focus:outline-none focus:ring-1 focus:ring-blue-600 shadow-sm"
          />
        </div>

        {/* Board */}
        <div className="grid grid-cols-1 lg:grid-cols-5 gap-4 overflow-x-auto pb-4">
          {columns.map(col => {
            const columnLeads = filteredLeads.filter(l => l.status === col.id);
            const colTotalValue = columnLeads.reduce((acc, c) => acc + c.value, 0);

            return (
              <div key={col.id} className="min-w-[220px] flex flex-col gap-3">
                {/* Column Header */}
                <div className={`p-4 rounded-xl border border-slate-200/60 dark:border-slate-800/60 ${col.color} flex justify-between items-center`}>
                  <div>
                    <h4 className="text-xs font-bold text-slate-800 dark:text-white">{col.label}</h4>
                    <span className="text-[10px] text-slate-500 font-bold">₹{(colTotalValue / 100000).toFixed(1)}L Total</span>
                  </div>
                  <span className="text-xs bg-white dark:bg-slate-900 border border-slate-200/60 dark:border-slate-800/80 px-2 py-0.5 rounded font-black text-slate-600 dark:text-slate-400">
                    {columnLeads.length}
                  </span>
                </div>

                {/* Column Leads Stack */}
                <div className="flex flex-col gap-3 min-h-[300px]">
                  {columnLeads.map(lead => (
                    <motion.div
                      layout
                      key={lead.id}
                      className="bg-white dark:bg-slate-900 border border-slate-200/50 dark:border-slate-800/60 rounded-xl p-4 card-shadow space-y-3.5 flex flex-col justify-between"
                    >
                      <div className="space-y-1.5">
                        <div className="flex justify-between items-start gap-2">
                          <h5 className="font-bold text-slate-800 dark:text-white text-xs leading-tight truncate">{lead.name}</h5>
                          <span className="text-[9px] font-black text-emerald-600 bg-emerald-50 dark:bg-emerald-950/20 px-1.5 py-0.5 rounded shrink-0">
                            ₹{(lead.value / 100000).toFixed(1)}L
                          </span>
                        </div>
                        <p className="text-[10px] text-slate-400 font-semibold flex items-center gap-1">
                          <Briefcase className="w-3 h-3" />
                          {lead.company}
                        </p>
                      </div>

                      {/* Contact metadata */}
                      <div className="text-[10px] text-slate-500 border-t border-slate-50 dark:border-slate-800 pt-2 flex flex-col gap-1 font-medium">
                        <div className="flex items-center gap-1.5">
                          <Mail className="w-3.5 h-3.5 text-slate-400" />
                          <span className="truncate">{lead.email}</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Phone className="w-3.5 h-3.5 text-slate-400" />
                          <span>{lead.phone}</span>
                        </div>
                      </div>

                      {/* Flow Control Trigger */}
                      {lead.status !== 'Customer' && (
                        <button 
                          onClick={() => handleAdvanceStatus(lead.id)}
                          className="w-full mt-1.5 py-1.5 border border-dashed border-slate-200 dark:border-slate-800 rounded-lg text-[10px] font-bold text-slate-500 hover:text-blue-600 dark:hover:text-blue-400 hover:border-blue-500 flex items-center justify-center gap-1 transition-colors"
                        >
                          Advance Pipeline
                          <ArrowRight className="w-3 h-3" />
                        </button>
                      )}
                    </motion.div>
                  ))}
                  {columnLeads.length === 0 && (
                    <div className="flex-1 border border-dashed border-slate-200 dark:border-slate-800/80 rounded-xl flex items-center justify-center text-slate-400 text-[10px] p-6 text-center font-medium">
                      No deals here
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Add Lead Sidebar Drawer (Form validation overlay) */}
      <AnimatePresence>
        {isAddingLead && (
          <div className="fixed inset-0 bg-slate-950/50 backdrop-blur-sm z-50 flex justify-end">
            <motion.div
              initial={{ x: '100%' }}
              animate={{ x: 0 }}
              exit={{ x: '100%' }}
              className="w-full max-w-md bg-white dark:bg-slate-900 border-l border-slate-200 dark:border-slate-800 h-screen p-6 space-y-6 flex flex-col justify-between"
            >
              <div className="space-y-4">
                <div>
                  <h3 className="text-lg font-bold text-slate-800 dark:text-white">Ingest New Sales Lead</h3>
                  <p className="text-xs text-slate-400 mt-1">Registers raw sales lead in pipeline for qualified tech assessment.</p>
                </div>

                <div className="space-y-4">
                  <div className="space-y-1.5">
                    <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Lead / Client Name</label>
                    <input 
                      type="text" 
                      placeholder="e.g. John Doe"
                      value={newLeadName}
                      onChange={(e) => setNewLeadName(e.target.value)}
                      className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                    />
                  </div>

                  <div className="space-y-1.5">
                    <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Company / Industry</label>
                    <input 
                      type="text" 
                      placeholder="e.g. Tesla Aerospace"
                      value={newLeadCompany}
                      onChange={(e) => setNewLeadCompany(e.target.value)}
                      className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                    />
                  </div>

                  <div className="space-y-1.5">
                    <label className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Estimated Project Value (INR)</label>
                    <input 
                      type="number" 
                      value={newLeadValue}
                      onChange={(e) => setNewLeadValue(Number(e.target.value))}
                      className="w-full bg-slate-100 dark:bg-slate-800 border-0 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-600 focus:outline-none"
                    />
                  </div>
                </div>
              </div>

              <div className="flex gap-3 pt-6 border-t border-slate-100 dark:border-slate-800">
                <button 
                  onClick={() => setIsAddingLead(false)}
                  className="flex-1 py-3 text-xs font-bold text-slate-400 border border-slate-200 dark:border-slate-800 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors"
                >
                  Cancel
                </button>
                <button 
                  onClick={addLead}
                  disabled={!newLeadName || !newLeadCompany}
                  className="flex-1 py-3 text-xs font-bold text-white bg-blue-600 hover:bg-blue-700 rounded-xl disabled:opacity-50 disabled:cursor-not-allowed shadow-md shadow-blue-500/20 transition-all"
                >
                  Save Lead
                </button>
              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
};
