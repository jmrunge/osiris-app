/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ar.com.zir.osiris.web.app.local;

import ar.com.zir.osiris.api.personas.profiles.Empleado;
import ar.com.zir.osiris.api.security.SystemUser;
import ar.com.zir.osiris.ejb.services.PersonaService;
import ar.com.zir.osiris.web.app.EntityConverter;
import ar.com.zir.osiris.web.app.personas.security.DuplicatedSessionException;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import javax.enterprise.context.ConversationScoped;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.inject.Inject;
import javax.inject.Named;

/**
 *
 * @author jmrunge
 */
@Named(value = "empleadoBean")
@ConversationScoped
public class EmpleadoBean implements Serializable {
    @Inject
    private PersonaService personaService;
    
    /**
     * Creates a new instance of EmpleadoBean
     */
    public EmpleadoBean() {
    }
    
    public List<Empleado> completeEmpleado(String query) throws DuplicatedSessionException {
        return (List<Empleado>) personaService.completeProfile("Empleado", query, getSystemUser());
    }

    private SystemUser getSystemUser() throws DuplicatedSessionException {
        SystemUser su = (SystemUser) FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get("systemUser");
        if (su == null)
            throw new DuplicatedSessionException("La sesión actual de este usuario ha sido cerrada por duplicidad");
        return su;
    }
    
    public Converter getEmpleadoConverter() throws DuplicatedSessionException {
        Collection<Empleado> empleados = personaService.getAllObjectsForProfile("Empleado", getSystemUser());
        return new EntityConverter(empleados);
    }

}
