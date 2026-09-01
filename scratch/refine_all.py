import re

def refine():
    with open('app_design_preview.html', 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. Update simulatorBottomNav to include Report tab matching Screenshot 2
    old_nav = """          <!-- FLOATING BOTTOM NAVIGATION (Customer Mode) -->
          <nav id="simulatorBottomNav" class="floating-nav">
            <div onclick="goToScreen('home')" class="nav-item active" data-nav="home">
              <i class="fa-solid fa-house text-lg"></i>
              <span class="text-[9px] font-bold mt-0.5">Home</span>
            </div>
            <div onclick="goToScreen('discover')" class="nav-item" data-nav="discover">
              <i class="fa-solid fa-compass text-lg"></i>
              <span class="text-[9px] font-bold mt-0.5">Discover</span>
            </div>
            <div onclick="goToScreen('bookings')" class="nav-item" data-nav="bookings">
              <i class="fa-solid fa-calendar-check text-lg"></i>
              <span class="text-[9px] font-bold mt-0.5">Bookings</span>
            </div>
            <!-- Messages Nav Item with Smart Unread Badge -->
            <div onclick="goToScreen('messages')" class="nav-item" data-nav="messages">
              <i class="fa-solid fa-comments text-lg"></i>
              <span class="nav-badge-dot"></span>
            </div>
            <div onclick="goToScreen('profile')" class="nav-item" data-nav="profile">
              <i class="fa-solid fa-user text-lg"></i>
            </div>
          </nav>"""

    new_nav = """          <!-- FLOATING BOTTOM NAVIGATION (Customer Mode Matching Reference Image 2) -->
          <nav id="simulatorBottomNav" class="floating-nav">
            <div onclick="goToScreen('home')" class="nav-item active" data-nav="home">
              <i class="fa-solid fa-house text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Home</span>
            </div>
            <div onclick="goToScreen('discover')" class="nav-item" data-nav="discover">
              <i class="fa-solid fa-compass text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Discover</span>
            </div>
            <div onclick="goToScreen('medical_records')" class="nav-item" data-nav="medical_records">
              <i class="fa-solid fa-chart-simple text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Report</span>
            </div>
            <div onclick="goToScreen('bookings')" class="nav-item" data-nav="bookings">
              <i class="fa-solid fa-calendar-check text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Bookings</span>
            </div>
            <div onclick="goToScreen('messages')" class="nav-item" data-nav="messages">
              <i class="fa-solid fa-comments text-base"></i>
              <span class="nav-badge-dot"></span>
              <span class="text-[9px] font-semibold mt-0.5">Chat</span>
            </div>
            <div onclick="goToScreen('profile')" class="nav-item" data-nav="profile">
              <i class="fa-regular fa-circle-user text-base"></i>
              <span class="text-[9px] font-semibold mt-0.5">Me</span>
            </div>
          </nav>"""

    if old_nav in html:
        html = html.replace(old_nav, new_nav)
    else:
        # Replace nav content
        html = re.sub(r'<nav id="simulatorBottomNav" class="floating-nav">[\s\S]*?</nav>', new_nav, html)

    # 2. Set medical_records hasNav: true so it shows the bottom navigation bar exactly as in Screenshot 2!
    html = re.sub(
        r'medical_records:\s*\{\s*id:\s*[\'\"]medical_records[\'\"],\s*num:\s*[\'\"]16[\'\"],\s*title:\s*[\'\"][^\'\"]+[\'\"],\s*category:\s*[\'\"]customer[\'\"],\s*role:\s*[\'\"]customer[\'\"],\s*hasNav:\s*false',
        "medical_records: {\n        id: 'medical_records',\n        num: '16',\n        title: '16. Health Reports & Medical Records',\n        category: 'customer',\n        role: 'customer',\n        hasNav: true",
        html
    )
    # Ensure phone-screen is used for medical_records
    html = html.replace(
        '<div class="phone-screen-no-nav p-5 bg-[#F5F6F8] flex flex-col justify-between h-full screen-fade">',
        '<div class="phone-screen p-5 bg-[#F5F6F8] flex flex-col justify-between screen-fade">'
    )

    # 3. Clean up any duplicate comments or headings
    html = html.replace("// ==========================================\n      // 16. MEDICAL RECORDS & REPORTS (SENIOR HEALTHCARE UI/UX)\n      // ==========================================\n            // ==========================================", "// ==========================================")

    # 4. Refine Family Members Screen (17) to match Screenshot 1 with 100% precision
    family_screen_exact = """      // ==========================================
      // 17. FAMILY MEMBERS & DEPENDENTS (EXACT MATCH TO REFERENCE IMAGE 1)
      // ==========================================
      family_members: {
        id: 'family_members',
        num: '17',
        title: '17. Family & Dependents',
        category: 'customer',
        role: 'customer',
        hasNav: false,
        render: () => `
          <div class="phone-screen-no-nav p-5 bg-[#F5F6F8] flex flex-col justify-between h-full screen-fade">
            <div class="overflow-y-auto pr-0.5 pb-4">
              
              <!-- Top Navigation Bar (Exact Reference Image 1) -->
              <div class="flex items-center justify-between mb-4 pt-1">
                <button onclick="goToScreen('profile')" class="w-9 h-9 rounded-full bg-white border border-slate-200/80 flex items-center justify-center text-slate-700 shadow-sm hover:bg-slate-50 cursor-pointer transition-all">
                  <i class="fa-solid fa-arrow-left text-xs"></i>
                </button>
                <h3 class="text-base font-extrabold text-slate-900">Family & Dependents</h3>
                <button class="w-9 h-9 rounded-full bg-purple-50 text-[#7C3AED] flex items-center justify-center text-xs font-bold hover:bg-purple-100 cursor-pointer transition-all shadow-xs" title="Add Family Member">
                  <i class="fa-solid fa-user-plus"></i>
                </button>
              </div>

              <!-- Family Health Hub Curved Purple Banner (Exact Reference Image 1) -->
              <div class="bg-gradient-to-r from-[#7C3AED] via-[#8B5CF6] to-[#6D28D9] rounded-[28px] p-5 text-white shadow-xl shadow-purple-500/25 mb-5 relative overflow-hidden">
                <div class="flex items-center justify-between mb-2.5">
                  <div class="flex items-center gap-2">
                    <i class="fa-solid fa-house-chimney-medical text-sm"></i>
                    <h4 class="text-sm font-extrabold tracking-tight">Family Health Hub</h4>
                  </div>
                  <span class="bg-white/20 backdrop-blur-md text-[10px] font-bold px-2.5 py-0.5 rounded-full border border-white/20">4 Members</span>
                </div>
                <p class="text-[11px] text-purple-100 leading-relaxed font-medium">Manage appointments, medical histories, and digital insurance cards for your entire household in one unified space.</p>
              </div>

              <!-- ACTIVE CARE ACCOUNT (Exact Reference Image 1) -->
              <div class="mb-5">
                <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider mb-3">Active Care Account</h4>
                <div class="grid grid-cols-4 gap-2.5 text-center">
                  
                  <!-- Member 1: Sajibur (Active) -->
                  <div class="p-2.5 bg-white rounded-3xl border-2 border-[#7C3AED] shadow-md shadow-purple-500/10 cursor-pointer relative flex flex-col items-center">
                    <div class="relative mb-1.5">
                      <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120&auto=format&fit=crop&q=80" class="w-12 h-12 rounded-full object-cover border-2 border-[#7C3AED]" />
                      <span class="w-4 h-4 bg-[#7C3AED] text-white rounded-full text-[9px] flex items-center justify-center absolute -top-1 -right-1 shadow-sm"><i class="fa-solid fa-check"></i></span>
                    </div>
                    <span class="text-[11px] font-extrabold text-slate-900 block truncate">Sajibur</span>
                    <span class="text-[9px] text-[#7C3AED] font-bold block">Primary</span>
                  </div>

                  <!-- Member 2: Nadia -->
                  <div class="p-2.5 bg-white rounded-3xl border border-slate-200/80 hover:border-purple-400 shadow-xs cursor-pointer flex flex-col items-center">
                    <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=120&auto=format&fit=crop&q=80" class="w-12 h-12 rounded-full object-cover mb-1.5" />
                    <span class="text-[11px] font-bold text-slate-800 block truncate">Nadia</span>
                    <span class="text-[9px] text-slate-400 font-semibold block">Spouse</span>
                  </div>

                  <!-- Member 3: Aayan -->
                  <div class="p-2.5 bg-white rounded-3xl border border-slate-200/80 hover:border-purple-400 shadow-xs cursor-pointer flex flex-col items-center">
                    <img src="https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?w=120&auto=format&fit=crop&q=80" class="w-12 h-12 rounded-full object-cover mb-1.5" />
                    <span class="text-[11px] font-bold text-slate-800 block truncate">Aayan</span>
                    <span class="text-[9px] text-slate-400 font-semibold block">Son (4y)</span>
                  </div>

                  <!-- Member 4: Farida -->
                  <div class="p-2.5 bg-white rounded-3xl border border-slate-200/80 hover:border-purple-400 shadow-xs cursor-pointer flex flex-col items-center">
                    <img src="https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?w=120&auto=format&fit=crop&q=80" class="w-12 h-12 rounded-full object-cover mb-1.5" />
                    <span class="text-[11px] font-bold text-slate-800 block truncate">Farida</span>
                    <span class="text-[9px] text-slate-400 font-semibold block">Mother</span>
                  </div>

                </div>
              </div>

              <!-- HOUSEHOLD MEMBERS DETAILS (Exact Reference Image 1) -->
              <div class="space-y-3.5 mb-3">
                <h4 class="text-xs font-extrabold text-slate-900 uppercase tracking-wider">Household Members Details</h4>

                <!-- Detail Card 1: Sajibur Rahman -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center gap-3">
                      <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" class="w-13 h-13 rounded-2xl object-cover border border-slate-200" />
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h5 class="text-xs font-extrabold text-slate-900">Sajibur Rahman</h5>
                          <span class="bg-purple-50 text-[#7C3AED] text-[9px] font-bold px-2 py-0.5 rounded-full">Primary Account</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">32 yrs • Male • Blood: O+ • Bupa Gold</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center justify-between pt-2.5 border-t border-slate-100 text-[11px]">
                    <span class="text-slate-500 font-medium flex items-center gap-1.5">
                      <i class="fa-solid fa-calendar-check text-[#7C3AED]"></i> Next: Aug 24 (Dr. Sarah)
                    </span>
                    <button onclick="goToScreen('edit_profile')" class="px-3.5 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-[10px] transition-all">Edit Details</button>
                  </div>
                </div>

                <!-- Detail Card 2: Nadia Rahman -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center gap-3">
                      <img src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&auto=format&fit=crop&q=80" class="w-13 h-13 rounded-2xl object-cover border border-slate-200" />
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h5 class="text-xs font-extrabold text-slate-900">Nadia Rahman</h5>
                          <span class="bg-purple-50 text-[#7C3AED] text-[9px] font-bold px-2 py-0.5 rounded-full">Spouse</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">29 yrs • Female • Blood: A+ • Bupa Dependent</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center justify-between pt-2.5 border-t border-slate-100 text-[11px]">
                    <span class="text-emerald-600 font-bold flex items-center gap-1.5">
                      <i class="fa-solid fa-circle-check"></i> Health Check Up-to-date
                    </span>
                    <div class="flex gap-2">
                      <button onclick="goToScreen('discover')" class="px-3 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold text-[10px] transition-all">Book Visit</button>
                      <button onclick="goToScreen('medical_records')" class="px-3 py-1.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-[10px] transition-all">Records</button>
                    </div>
                  </div>
                </div>

                <!-- Detail Card 3: Aayan Rahman -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center gap-3">
                      <img src="https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?w=150&auto=format&fit=crop&q=80" class="w-13 h-13 rounded-2xl object-cover border border-slate-200" />
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h5 class="text-xs font-extrabold text-slate-900">Aayan Rahman</h5>
                          <span class="bg-pink-50 text-pink-600 text-[9px] font-bold px-2 py-0.5 rounded-full">Child (4y)</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">Pediatric Care • Blood: O+ • Vaccinations Current</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center justify-between pt-2.5 border-t border-slate-100 text-[11px]">
                    <span class="text-[#7C3AED] font-bold flex items-center gap-1.5">
                      <i class="fa-solid fa-shield-virus"></i> MMR Vaccine Completed
                    </span>
                    <button onclick="goToScreen('details')" class="px-3.5 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold text-[10px] transition-all">Schedule Visit</button>
                  </div>
                </div>

                <!-- Detail Card 4: Farida Begum -->
                <div class="bg-white rounded-3xl p-4 border border-slate-100 shadow-sm">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center gap-3">
                      <img src="https://images.unsplash.com/photo-1581579438747-1dc8d17bbce4?w=150&auto=format&fit=crop&q=80" class="w-13 h-13 rounded-2xl object-cover border border-slate-200" />
                      <div>
                        <div class="flex items-center gap-2 mb-0.5">
                          <h5 class="text-xs font-extrabold text-slate-900">Farida Begum</h5>
                          <span class="bg-amber-50 text-amber-600 text-[9px] font-bold px-2 py-0.5 rounded-full">Parent</span>
                        </div>
                        <p class="text-[10px] text-slate-400 font-medium">64 yrs • Female • Cardiology Monitoring</p>
                      </div>
                    </div>
                  </div>
                  <div class="flex items-center justify-between pt-2.5 border-t border-slate-100 text-[11px]">
                    <span class="text-amber-600 font-bold flex items-center gap-1.5">
                      <i class="fa-solid fa-heart-pulse"></i> Monthly ECG Due in 5d
                    </span>
                    <button onclick="goToScreen('details')" class="px-3.5 py-1.5 rounded-xl bg-purple-50 hover:bg-purple-100 text-[#7C3AED] font-bold text-[10px] transition-all">Book ECG</button>
                  </div>
                </div>

              </div>

            </div>

            <!-- Sticky Add Member Button (Exact Reference Image 1) -->
            <div class="pt-3 bg-[#F5F6F8] border-t border-slate-200/60 sticky bottom-0">
              <button class="w-full py-3.5 rounded-2xl bg-[#7C3AED] hover:bg-[#6D28D9] text-white font-bold text-xs shadow-lg shadow-purple-500/30 flex items-center justify-center gap-2 transition-all cursor-pointer">
                <i class="fa-solid fa-user-plus text-xs"></i>
                <span>Add Family Member or Dependent</span>
              </button>
            </div>

          </div>
        `
      },"""

    pattern_fam = r'family_members:\s*\{[\s\S]*?insurance_cards:\s*\{'
    html = re.sub(pattern_fam, family_screen_exact + "\n\n      // ==========================================\n      // 18. INSURANCE CARDS & DIGITAL COVERAGE\n      // ==========================================\n      insurance_cards: {", html)

    # 5. Fix any lingering blue sidebar styles to purple
    html = html.replace('bg-blue-600 text-white shadow-md shadow-blue-500/20', 'bg-[#7C3AED] text-white shadow-md shadow-purple-500/20')
    html = html.replace('text-blue-400', 'text-purple-400')
    html = html.replace('hover:text-blue-400', 'hover:text-purple-400')
    html = html.replace('hover:bg-blue-600/10', 'hover:bg-purple-600/10')
    html = html.replace('text-blue-600', 'text-[#7C3AED]')
    html = html.replace('text-blue-700', 'text-[#6D28D9]')
    html = html.replace('text-blue-300', 'text-purple-300')
    html = html.replace('text-blue-100', 'text-purple-100')
    html = html.replace('bg-blue-600', 'bg-[#7C3AED]')
    html = html.replace('hover:bg-blue-700', 'hover:bg-[#6D28D9]')
    html = html.replace('border-blue-600', 'border-[#7C3AED]')
    html = html.replace('shadow-blue-500/20', 'shadow-purple-500/20')
    html = html.replace('shadow-blue-500/30', 'shadow-purple-500/30')
    html = html.replace('shadow-blue-500/25', 'shadow-purple-500/25')

    with open('app_design_preview.html', 'w', encoding='utf-8') as f:
        f.write(html)
    print("Refinement completed successfully!")

if __name__ == '__main__':
    refine()
