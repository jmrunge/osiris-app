/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package ar.com.zir.osiris.web.app.local;

import ar.com.zir.osiris.web.app.LocalNodesBeanInterface;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.enterprise.context.ConversationScoped;
import javax.inject.Named;

/**
 *
 * @author jmrunge
 */
@Named(value="localNodesBean")
@ConversationScoped
public class LocalNodesBean implements LocalNodesBeanInterface, Serializable {

    /** Creates a new instance of LocalNodesBean */
    public LocalNodesBean() {
    }
    
    @Override
    public List<String[]> getLocalNodeTypes() {
        List<String[]> nodeTypes = new ArrayList<>();
        return nodeTypes;
    }

}
